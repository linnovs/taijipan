import QtQuick
import QtQuick.Layouts
import qs.Widgets
import qs.Commons

Item {
  id: root

  required property TextInput passwordInput
  required property LockContext context

  RainbowGradient {
    id: rainbowGradient
  }

  RowLayout {
    anchors.fill: parent
    anchors.bottom: parent.bottom

    Item {
      Layout.preferredWidth: Theme.marginXL
    }

    PasswordInput {
      id: passwordField
      Layout.fillWidth: true
      Layout.preferredHeight: Theme.marginXL
      passwordInput: root.passwordInput
      isError: context.isErrorMessage

      Rectangle {
        anchors.centerIn: passwordField
        width: passwordField.width + 2
        height: passwordField.height + 2
        radius: Theme.radiusRound
        gradient: rainbowGradient.gradient
        visible: context.isUnlocking
        z: -1
      }
    }

    Item {
      Layout.preferredWidth: Theme.marginXL
    }
  }

  Connections {
    target: context
    function onFailed() {
      passwordField.failedAttempt();
    }
  }

  implicitWidth: Theme.widthMD
  implicitHeight: Theme.heightSM
}
