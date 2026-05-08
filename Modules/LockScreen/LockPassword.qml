import QtQuick
import QtQuick.Layouts
import qs.Commons

Item {
  id: root

  required property TextInput passwordInput
  required property LockContext context

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
