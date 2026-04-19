import QtQuick
import qs.Commons

Rectangle {
  id: cardBackground

  property int urgency
  property real progress

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
