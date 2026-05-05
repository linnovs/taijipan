pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import qs.Commons

Singleton {
  id: root

  ListModel {
    id: popupModel
  }
  readonly property alias popups: popupModel
  readonly property int maxPopupCount: 5

  // Emitted when a notification expires and is removed from the popup list. The id parameter is the internalId of the
  // expired notification.
  signal notificationExpiring(string id)

  property var popupStates: ({})

  ListModel {
    id: historyModel
  }
  readonly property alias histories: historyModel
  readonly property int maxHistoryCount: 50

  function parseNotification(notification) {
    const now = Date.now();
    const actions = notification.actions.map(action => {
      return {
        identifier: action.identifier,
        text: action.text
      };
    });
    let noti = {
      internalId: notification.id,
      icon: notification.appIcon || "",
      appName: notification.appName || notification.desktopEntry,
      urgency: notification.urgency,
      title: notification.summary.trim(),
      body: notification.body.trim(),
      actions: actions,
      image: notification.image,
      hasActionIcons: notification.hasActionIcons,
      timestamp: now,
      progress: 1.0
    };
    noti.id = Checksum.sha256(JSON.stringify({
      appName: noti.appName,
      title: noti.title,
      body: noti.body,
      timestamp: noti.timestamp
    }));

    return noti;
  }

  function saveToHistory(data, notification) {
    if (notification.transient)
      return;

    Qt.callLater(() => {
      historyModel.insert(0, data);

      while (historyModel.count > maxHistoryCount) {
        const lastIdx = historyModel.count - 1;
        const lastHist = historyModel.get(lastIdx);
        historyModel.remove(lastIdx);
        removePopup(lastHist.id);
      }
    });
  }

  function progressUpdate() {
    const now = Date.now();
    const toRemove = [];

    for (let i = popupModel.count - 1; i >= 0; i--) {
      const noti = popupModel.get(i);
      const state = popupStates[noti.id];
      if (!state)
        continue;
      if (state.ttl === -1 || state.paused)
        continue;
      const elapsed = now - state.timestamp;
      const progress = Math.max(1.0 - (elapsed / state.ttl), 0.0);

      if (progress <= 0) {
        toRemove.push(noti.id);
      } else if (Math.abs(noti.progress - progress) > 0.005) {
        popupModel.setProperty(i, "progress", progress);
      }
    }

    if (toRemove.length > 0)
      notificationExpiring(toRemove[0]);
  }

  Timer {
    interval: 50
    running: popupModel.count > 0
    repeat: true
    onTriggered: progressUpdate()
  }

  function calculateTTL(notification) {
    if (notification.expireTimeout > 0) {
      return notification.expireTimeout;
    } else if (notification.expireTimeout === 0) {
      return -1; // never expire
    }

    switch (notification.urgency) {
    case NotificationUrgency.Low:
      return Settings.data.notification.lowUrgencyTTL * 1000 || 3000;
    case NotificationUrgency.Normal:
      return Settings.data.notification.defaultTTL * 1000 || 5000;
    case NotificationUrgency.Critical:
      return -1; // never expire
    default:
      return Settings.data.notification.defaultTTL * 1000 || 5000;
    }
  }

  function findPopupIndexById(id) {
    for (let i = 0; i < popupModel.count; i++) {
      if (popupModel.get(i).id === id) {
        return i;
      }
    }
    return -1;
  }

  function dismissPopup(id) {
    const idx = findPopupIndexById(id);
    if (idx >= 0) {
      popupModel.remove(idx);
    }
  }

  function removePopup(id) {
    dismissPopup(id);
    delete popupStates[id];
  }

  function addPopup(data, notification) {
    function onClosed() {
      dismissPopup(data.id);
    }

    popupStates[data.id] = {
      notification: notification,
      ttl: calculateTTL(notification),
      timestamp: data.timestamp,
      paused: false,
      pausedAt: null,
      closedHandler: onClosed,
      actionMap: notification.actions.reduce((acc, action) => {
        acc[action.identifier] = action;
        return acc;
      }, {})
    };

    notification.tracked = true;
    notification.closed.connect(onClosed);

    Qt.callLater(() => {
      popupModel.insert(0, data);

      while (popupModel.count > maxPopupCount) {
        const lastNoti = popupModel.get(popupModel.count - 1);
        popupStates[lastNoti.id]?.notification?.dismiss();
      }
    });
  }

  function handleNotification(notification) {
    const noti = parseNotification(notification);

    saveToHistory(noti, notification);
    addPopup(noti, notification);
  }

  function updateModel(model, id, prop, value) {
    for (let i = 0; i < model.count; i++) {
      if (model.get(i).id === id) {
        model.setProperty(i, prop, value);
        break;
      }
    }
  }

  function invokeAction(notificationId, actionIdentifier) {
    const state = popupStates[notificationId];
    if (!state) {
      Logger.w("NotificationService", "No state found for notification ID", `'${notificationId}'`);
      return false;
    }

    const actionObj = state.actionMap[actionIdentifier];
    if (!actionObj) {
      Logger.w("NotificationService", "No action found for identifier", `'${actionIdentifier}'`, "in notification ID", `'${notificationId}'`);
      return false;
    }

    if (actionObj.invoke) {
      try {
        actionObj.invoke();
      } catch (e) {
        Logger.w("NotificationService", "invoke() failed:", e);
        return false;
      }
    } else {
      Logger.w("NotificationService", "Action does not have an invoke method");
      return false;
    }

    // clear actions after invocation to prevent multiple invocations
    updateModel(popupModel, notificationId, "actions", []);
    updateModel(historyModel, notificationId, "actions", []);

    return true;
  }

  NotificationServer {
    id: notificationServer
    keepOnReload: false
    imageSupported: true
    actionsSupported: true
    onNotification: notification => handleNotification(notification)
  }

  function init() {
    Logger.i("NotificationService", "Notification registered");
  }
}
