import QtQuick
import QtQuick.Layouts
import qs.Commons

Item {
  id: root

  required property TextInput passwordInput

  RowLayout {
    anchors.fill: parent
    anchors.bottom: parent.bottom

    Item {
      Layout.preferredWidth: Theme.marginXL
    }

    PasswordInput {
      Layout.fillWidth: true
      Layout.preferredHeight: Theme.marginXL
      passwordInput: root.passwordInput
    }

    Item {
      Layout.preferredWidth: Theme.marginXL
    }
  }

  implicitWidth: Theme.widthMD
  implicitHeight: Theme.heightSM
}
