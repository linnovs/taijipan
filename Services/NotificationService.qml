pragma ComponentBehavior: Bound
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import qs.Commons

Singleton {
  id: root

  property int maxVisible: 5
  property int maxHistory: 100
  property string historyFile: Paths.joinDir(Paths.cache, "notifications.json")

  property real lastSeenTimestamp: 0
  property bool doNotDisturb: false

  property ListModel notifierModel: ListModel {}
  property ListModel historyModel: ListModel {}

  property var notifierState: ({})
  property var clientIdMap: ({})

  property var notificationServerLoader: null

  function parseNotification(noti) {
    const now = new Date();
    const id = Checksum.sha256(JSON.stringify({
      summary: noti.summary,
      body: noti.body,
      app: noti.app,
      time: now.getTime()
    }));

    return {
      id,
      summary: noti.summary,
      body: noti.body,
      appName: noti.appName,
      urgency: noti.urgency,
      expireTimeout: noti.expireTimeout,
      timestamp: now,
      progress: 1.0,
      appIcon: noti.appIcon,
      imageSource: noti.image,
      originalId: noti.originalId || noti.id || 0,
      actionsJson: JSON.stringify((noti.actions || []).map(action => ({
            text: (action.text || "").trim() || "Action",
            identifier: action.identifier || ""
          })))
    };
  }

  function addToHistory(data, notification) {
    if (notification.transient)
      return;
    Qt.callLater(() => {
      historyModel.insert(0, data);
      while (historyModel.count > maxHistory) {
        historyModel.remove(historyModel.count - 1);
      }
    });
  }

  function findNotifierIndex(dataId) {
    for (var i = 0; i < notifierModel.count; i++) {
      if (notifierModel.get(i).id === dataId) {
        return i;
      }
    }
    return -1;
  }

  function calDuration(data) {
    const durations = [Settings.data.notifications.timeouts.low * 1000 || 3000, Settings.data.notifications.timeouts.normal * 1000 || 5000, Settings.data.notifications.timeouts.critical * 1000 || -1,];

    if (data.expireTimeout === 0) {
      return -1; // never expire
    } else if (data.expireTimeout > 0) {
      return data.expireTimeout;
    }

    return durations[data.urgency];
  }

  function dismissNotifier(id) {
    const idx = findNotifierIndex(id);
    if (idx >= 0)
      notifierModel.remove(idx);
  }

  function addNotifier(clientId, notification, data) {
    clientIdMap[clientId] = data.id;

    notifierState[data.id] = {
      notification,
      metadata: {
        originalId: data.originalId,
        paused: false,
        timestamp: data.timestamp.getTime(),
        duration: calDuration(data),
        urgency: data.urgency
      }
    };

    function onClosed() {
      dismissNotifier(data.id);
    }

    notification.tracked = true;
    notification.closed.connect(onClosed);
    notifierState[data.id].onClosed = onClosed;

    Qt.callLater(() => {
      notifierModel.insert(0, data);

      // Remove excess notifiers if we exceed the max visible count
      while (notifierModel.count > maxVisible) {
        const last = notifierModel.get(notifierModel.count - 1);
        notifierState[last.id]?.notification?.dismiss();
      }
    });
  }

  function handleNotification(notification) {
    const clientId = notification.id;
    const data = parseNotification(notification);

    addToHistory(data, notification);
    addNotifier(clientId, notification, data);
  }

  signal notifierTimeouted(string notificationId)

  function updateNotifierProgress() {
    const now = Date.now();
    const toRemove = [];

    for (var i = 0; i < notifierModel.count; i++) {
      const noti = notifierModel.get(i);
      const notiState = notifierState[noti.id];
      if (!notiState)
        continue;
      const meta = notiState.metadata;
      if (meta.duration === -1 || meta.paused)
        continue;
      const elapsed = now - meta.timestamp;
      const progress = Math.max(0.0, 1.0 - (elapsed / meta.duration));

      if (Math.abs(noti.progress - progress) > 0.01)
        notifierModel.setProperty(i, "progress", progress);
      else if (progress <= 0)
        toRemove.push(noti.id);
    }

    if (toRemove.length > 0)
      root.notifierTimeouted(toRemove[0]);
  }

  function pause(id) {
    const notiState = notifierState[id];
    if (notiState && !notiState.metadata.paused) {
      notiState.metadata.paused = true;
      notiState.metadata.pauseTime = Date.now();
    }
  }

  function resume(id) {
    const notiState = notifierState[id];
    if (notiState && notiState.metadata.paused) {
      notiState.metadata.timestamp += Date.now() - notiState.metadata.pauseTime;
      notiState.metadata.paused = false;
    }
  }

  Timer {
    interval: 50
    repeat: true
    running: notifierModel.count > 0
    onTriggered: updateNotifierProgress()
  }

  Component {
    id: serverComponent
    NotificationServer {
      keepOnReload: false
      imageSupported: true
      actionsSupported: true
      onNotification: notification => root.handleNotification(notification)
    }
  }

  function reloadServer() {
    if (notificationServerLoader) {
      notificationServerLoader.destroy();
      notificationServerLoader = null;
    }

    if (Settings.isLoaded) {
      notificationServerLoader = serverComponent.createObject(root);
    }
  }

  function loadState() {
    try {
      const notiState = ShellState.data.notifications;
      root.lastSeenTimestamp = notiState.lastSeenTimestamp || 0;

      Logger.d("NotificationService", "State loaded. Last seen timestamp:", root.lastSeenTimestamp);
    } catch (error) {
      Logger.e("NotificationService", "Failed to load state:", error);
    }
  }

  Component.onCompleted: {
    if (Settings.isLoaded) {
      reloadServer();
    }

    Qt.callLater(() => {
      if (typeof ShellState !== undefined && ShellState.isLoaded) {
        loadState();
      }
    });
  }
}
