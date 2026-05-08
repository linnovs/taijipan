import QtQuick
import Quickshell
import qs.Widgets
import qs.Commons

Rectangle {
  required property TextInput passwordInput
  property bool showPassword: false

  radius: Theme.radiusRound
  color: Colors.mSurface
  border.color: passwordInput.activeFocus ? Colors.mPrimary : Qt.alpha(Colors.mOutline, 0.3)
  border.width: passwordInput.activeFocus ? 2 : 1

  MouseArea {
    anchors.fill: parent
    onClicked: passwordInput.forceActiveFocus()
  }

  TextIcon {
    id: lockIcon
    anchors.left: parent.left
    anchors.leftMargin: Theme.marginSM
    anchors.verticalCenter: parent.verticalCenter
    icon: "lock_person"
  }

  TextIcon {
    id: eyeIcon
    anchors.right: parent.right
    anchors.rightMargin: Theme.marginSM
    anchors.verticalCenter: parent.verticalCenter

    HoverHandler {
      id: eyeHoverHandler
    }

    MouseArea {
      anchors.fill: parent
      acceptedButtons: Qt.LeftButton
      onClicked: showPassword = !showPassword
    }

    icon: showPassword ? "visibility" : "visibility_off"
  }

  Item {
    anchors.left: lockIcon.right
    anchors.leftMargin: Theme.marginXXS
    anchors.right: eyeIcon.left
    anchors.rightMargin: Theme.marginXXS
    height: parent.height
    clip: true

    Row {
      anchors.verticalCenter: parent.verticalCenter
      anchors.horizontalCenter: parent.horizontalCenter
      height: Theme.fontSizeXL
      spacing: Theme.spacing

      Row {
        id: passwordDisplay
        anchors.verticalCenter: parent.verticalCenter
        visible: !showPassword
        spacing: Theme.marginXXS

        Repeater {
          model: ScriptModel {
            values: Array(passwordInput.text.length)
          }
          TextIcon {
            icon: "circle"
            fill: true
          }
        }
      }

      Text {
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        text: passwordInput.text
        visible: showPassword
        font.family: Settings.data.ui.font
        font.pixelSize: Theme.fontSizeLG
        verticalAlignment: Text.AlignVCenter
        color: Colors.mOnSurface
      }

      Rectangle {
        width: 2
        height: parent.height
        color: Colors.mOnSurface
        visible: passwordInput.activeFocus

        SequentialAnimation on opacity {
          loops: Animation.Infinite
          running: passwordInput.activeFocus
          NumberAnimation {
            to: 0
            duration: Theme.animationSlowest + Theme.animationBuffer
          }
          NumberAnimation {
            to: 1
            duration: Theme.animationSlowest + Theme.animationBuffer
          }
        }
      }
    }
  }
}
