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

      required property var modelData

      Layout.preferredWidth: Theme.notificationWidth + notificationStack.shadowPadding * 2
      Layout.preferredHeight: notificationCard.contentHeight + Theme.marginM * 3 + notificationStack.shadowPadding * 2
      Layout.maximumHeight: Layout.preferredHeight

      property real cardOffset: Layout.preferredWidth
      property real cardScale: 0.8
      property real cardOpacity: 0.0

      Timer {
        id: dismissTimer
        interval: Theme.animationNormal
        onTriggered: NotificationService.dismissNotifier(modelData.id)
      }

      property var timeoutHandler: null
      property bool isClosing: false

      Timer {
        id: entryDelayTimer
        interval: Theme.animationBuffer
        repeat: false
        onTriggered: {
          cardOffset = 0;
          cardScale = 1.0;
          cardOpacity = 1.0;
        }
      }

      Component.onCompleted: {
        timeoutHandler = function (id) {
          if (isClosing)
            return;

          if (modelData.id === id)
            notificationCard.close();
        };

        NotificationService.notifierTimeouted.connect(timeoutHandler);
        entryDelayTimer.start();
      }

      Component.onDestruction: {
        if (timeoutHandler) {
          NotificationService.notifierTimeouted.disconnect(timeoutHandler);
          timeoutHandler = null;
        }
      }

      NotificationCard {
        id: notificationCard

        cardData: notification.modelData

        anchors.fill: parent
        anchors.margins: shadowPadding

        scale: cardScale
        opacity: cardOpacity
        offset: cardOffset

        onHoveredChanged: hovered => {
          if (hovered)
            NotificationService.pause(cardData.id);
          else
            NotificationService.resume(cardData.id);
        }

        onClose: {
          notification.isClosing = true;
          offset = notificationCard.width;
          scale = 0.85;
          opacity = 0;
          dismissTimer.start();
        }
      }
    }
  }
}
