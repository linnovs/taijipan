import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons

Item {
  id: root
  anchors.fill: parent

  required property LockContext context
  required property ShellScreen screen

  opacity: 0

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

    LockClock {
      Layout.alignment: Qt.AlignHCenter
    }

    Item {
      Layout.preferredHeight: Theme.heightMD
    }

    LockUser {
      Layout.alignment: Qt.AlignHCenter
    }

    Item {
      Layout.preferredHeight: Theme.marginXXS
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

  UptimeMessage {
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.rightMargin: Theme.marginMD
    anchors.bottomMargin: Theme.marginMD
  }

  signal fadeOutFinished

  NumberAnimation {
    id: fadeOutAnimation
    target: root
    property: "opacity"
    from: 1
    to: 0
    duration: Theme.animationFast
    onStopped: root.fadeOutFinished()
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
    function onUnlocked() {
      fadeOutAnimation.running = true;
    }
  }

  NumberAnimation {
    id: fadeAnimation
    target: root
    property: "opacity"
    from: 0
    to: 1
    duration: Theme.animationNormal
  }

  Timer {
    id: fadeInTimer
    interval: Theme.timerDelay
    running: true
    repeat: false
    onTriggered: fadeAnimation.running = true
  }
}
