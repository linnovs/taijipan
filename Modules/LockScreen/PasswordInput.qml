import QtQuick
import Quickshell
import qs.Widgets
import qs.Commons

Rectangle {
  required property TextInput passwordInput
  property bool showPassword: false
  property bool isError: false
  property int originalX: 0

  property color nonErrorBorderColor: passwordInput.activeFocus ? Colors.mPrimary : Qt.alpha(Colors.mOutline, 0.3)
  property color currentBorderColor: isError ? Colors.mError : nonErrorBorderColor

  radius: Theme.radiusRound
  color: Colors.mSurface
  border.color: currentBorderColor
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

    Text {
      anchors.centerIn: parent
      visible: passwordInput.text.length === 0
      text: "PASSWORD or FIDO2"
      color: Qt.alpha(Colors.mSurfaceVariant, 0.8)
    }

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
        visible: passwordInput.activeFocus && passwordInput.text.length > 0

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

  NumberAnimation on x {
    id: shakeAnimation
    from: root.x - 5
    to: root.x + 5
    duration: Theme.animationFastest
    loops: 5
    running: isError
    onStopped: root.x = originalX
  }

  signal failedAttempt

  Timer {
    id: resetErrorTimer
    interval: 2000
    repeat: false
    onTriggered: {
      isError = false;
    }
  }

  onFailedAttempt: {
    originalX = root.x;
    isError = true;
    resetErrorTimer.restart();
  }
}
