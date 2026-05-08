import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons

Item {
  id: root
  anchors.fill: parent

  required property LockContext context
  required property ShellScreen screen

  TextInput {
    id: passwordInput
    visible: false

    onTextChanged: {
      if (context.password !== text)
        context.password = text;
    }

    Keys.onPressed: function (event) {
      if (Keybinds.isKeybindPressed(event, Settings.data.general.keybinds.enter)) {
        context.tryUnlock();
        event.accepted = true;
      }
      if (Keybinds.isKeybindPressed(event, Settings.data.general.keybinds.esc)) {
        passwordInput.text = "";
        event.accepted = true;
      }
    }

    Component.onCompleted: forceActiveFocus()
  }

  Background {
    id: background
    screen: root.screen
  }

  ColumnLayout {
    anchors.centerIn: parent
    implicitHeight: screen.height * 0.5

    LockClock {
      Layout.alignment: Qt.AlignHCenter
    }

    LockPassword {
      Layout.alignment: Qt.AlignHCenter
      passwordInput: passwordInput
      context: root.context
    }

    LockMessage {
      Layout.alignment: Qt.AlignHCenter
      context: root.context
    }
  }

  Connections {
    target: context
    function onIsUnlockingChanged() {
      if (context.isUnlocking)
        background.forceActiveFocus();
    }
    function onFailed() {
      passwordInput.text = "";
      passwordInput.forceActiveFocus();
    }
  }
}
