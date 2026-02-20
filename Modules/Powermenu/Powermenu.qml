import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Scope {
  id: root

  signal close()

  property string currentUptime

  Process {
    id: uptime
    command: ["uptime", "-p"]
    stdout: StdioCollector {
      onStreamFinished: {
        root.currentUptime = this.text.trim().replace("up ", "")
      }
    }
  }

  Timer {
    interval: 60 * 1000
    repeat: true
    running: true
    triggeredOnStart: true
    onTriggered: {
      uptime.running = true
    }
  }

  Menu {
    onClose: root.close()
    uptimeText: root.currentUptime

    LogoutButton {
      command: "swaylock"
      keybind: Qt.Key_Return
      text: "Lock"
      icon: "lockscreen"
    }

    LogoutButton {
      command: "loginctl terminate-user $USER"
      keybind: Qt.Key_L
      text: "Logout"
      icon: "logout"
    }

    LogoutButton {
      command: "systemctl suspend"
      keybind: Qt.Key_S
      text: "Suspend"
      icon: "suspend"
    }

    LogoutButton {
      command: "systemctl hibernate"
      keybind: Qt.Key_H
      text: "Hibernate"
      icon: "hibernate"
    }

    LogoutButton {
      command: "systemctl poweroff"
      keybind: Qt.Key_S
      shifted: true
      text: "Shutdown"
      icon: "shutdown"
    }

    LogoutButton {
      command: "systemctl reboot"
      keybind: Qt.Key_R
      text: "Reboot"
      icon: "reboot"
    }
  }
}
