import QtQuick
import QtQuick.Layouts
import qs.Services
import qs.Commons

ColumnLayout {
  id: notificationStack

  required property int shadowPadding
  required property ListModel notifierModel

  anchors.top: parent.top
  anchors.right: parent.right
  spacing: -shadowPadding * 2 + Theme.marginM

  Repeater {
    model: notifierModel
    delegate: Item {
      id: notification

      Layout.preferredWidth: Theme.notificationWidth + notificationStack.shadowPadding * 2
      Layout.preferredHeight: notificationCard.contentHeight + Theme.marginM * 3 + notificationStack.shadowPadding * 2
      Layout.maximumHeight: Layout.preferredHeight

      Timer {
        id: dismissTimer
        interval: Theme.animationNormal
        onTriggered: NotificationService.dismissNotifier(model.id)
      }

      property var timeoutHandler: null
      property bool isClosing: false

      Component.onCompleted: {
        timeoutHandler = function (id) {
          if (isClosing)
            return;

          if (model.id === id)
            notificationCard.close();
        };

        NotificationService.notifierTimeouted.connect(timeoutHandler);
      }

      Component.onDestruction: {
        if (timeoutHandler) {
          NotificationService.notifierTimeouted.disconnect(timeoutHandler);
          timeoutHandler = null;
        }
      }

      NotificationCard {
        id: notificationCard

        anchors.fill: parent
        anchors.margins: shadowPadding

        appIcon: model.appIcon
        imageSource: model.imageSource
        urgency: model.urgency
        progress: model.progress
        timestamp: model.timestamp
        appName: model.appName
        summary: model.summary
        body: model.body

        onHoveredChanged: hovered => {
          if (hovered)
            NotificationService.pause(model.id);
          else
            NotificationService.resume(model.id);
        }

        onClose: {
          notification.isClosing = true;
          offset = notification.width;
          scale = 0.85;
          opacity = 0;
          dismissTimer.start();
        }

        Behavior on opacity {
          NumberAnimation {
            duration: Theme.animationNormal
            easing.type: Easing.InOutQuad
          }
        }

        Behavior on scale {
          NumberAnimation {
            duration: Theme.animationNormal
            easing.type: Easing.InOutQuad
          }
        }
      }
    }
  }
}
