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
    width: 0
    height: 0
    enabled: !context.isUnlocking
    echoMode: TextInput.Password
    passwordMaskDelay: 0
    visible: false

    onTextChanged: {
      if (context.password !== text)
        context.password = text;
    }

    Connections {
      target: context
      function onPasswordChanged() {
        if (passwordInput.text !== context.password)
          passwordInput.text = context.password;
      }
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

    Component.onCompleted: passwordInput.forceActiveFocus()
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
      input: passwordInput
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
