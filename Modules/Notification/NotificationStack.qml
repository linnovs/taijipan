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

      property real offset: 0

      Behavior on offset {
        NumberAnimation {
          duration: Theme.animationNormal
          easing.type: Easing.InOutQuad
        }
      }

      Layout.preferredWidth: Theme.notificationWidth + notificationStack.shadowPadding * 2
      Layout.preferredHeight: notificationCard.contentHeight + Theme.marginM * 3 + notificationStack.shadowPadding * 2
      Layout.maximumHeight: Layout.preferredHeight

      transform: Translate {
        x: offset
      }

      Timer {
        id: dismissTimer
        interval: Theme.animationNormal
        onTriggered: NotificationService.dismissNotifier(model.id)
      }

      NotificationCard {
        id: notificationCard

        anchors.fill: parent
        anchors.margins: shadowPadding

        notificationId: model.id
        appIcon: model.appIcon
        imageSource: model.imageSource
        urgency: model.urgency
        progress: model.progress
        timestamp: model.timestamp
        appName: model.appName
        summary: model.summary
        body: model.body

        onClose: {
          scale = 0.85;
          opacity = 0;
          notification.offset = notification.width;
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
