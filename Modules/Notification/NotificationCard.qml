import QtQuick
import qs.Widgets
import qs.Services
import qs.Commons

Item {
  id: card

  readonly property int contentHeight: cardContent.implicitHeight

  property string notificationId
  property string appIcon
  property string imageSource
  property int urgency
  property real progress
  property date timestamp
  property string appName
  property string summary
  property string body

  HoverHandler {
    onHoveredChanged: {
      if (hovered) {
        NotificationService.pause(notificationId);
      } else {
        NotificationService.resume(notificationId);
      }
    }
  }

  Rectangle {
    id: cardBackground

    anchors.fill: parent
    radius: Theme.radiusM
    color: Qt.alpha(Colors.mSurface, 0.9)
    border.color: Qt.alpha(Colors.mOutline, 0.9)
    border.width: Theme.borderS

    Rectangle {
      anchors.top: parent.top
      anchors.right: parent.right
      anchors.left: parent.left
      height: 2
      color: "transparent"

      Rectangle {
        id: progressBar
        readonly property real progressWidth: cardBackground.width - (2 * cardBackground.radius)
        height: parent.height
        x: cardBackground.radius + (progressWidth * (1 - progress)) / 2
        width: progressWidth * progress
        antialiasing: true
        color: {
          var baseColor = urgency === 2 ? Colors.mError : urgency === 0 ? Colors.mOnSurface : Colors.mPrimary;
          return Qt.alpha(baseColor, 0.9);
        }

        Behavior on x {
          NumberAnimation {
            duration: Theme.animationFast
            easing.type: Easing.Linear
          }
        }

        Behavior on width {
          NumberAnimation {
            duration: Theme.animationFast
            easing.type: Easing.Linear
          }
        }
      }
    }
  }

  DropShadow {
    anchors.fill: cardBackground
    source: cardBackground
    autoPaddingEnabled: true
  }

  signal close

  MouseArea {
    anchors.fill: cardBackground
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: mouse => {
      if (mouse.button === Qt.RightButton)
        close();
    }
  }

  NotificationCardContent {
    id: cardContent
    background: cardBackground
    appIcon: card.appIcon
    imageSource: card.imageSource
    urgency: card.urgency
    progress: card.progress
    timestamp: card.timestamp
    appName: card.appName
    summary: card.summary
    body: card.body
  }
}
