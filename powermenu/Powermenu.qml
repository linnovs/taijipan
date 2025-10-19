import QtQuick
import QtQuick.Layouts
import Quickshell

Scope {
  id: root

  signal close()

  Menu {
    onClose: root.close()

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
