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
      icon: "system-lock-screen-symbolic"
    }

    LogoutButton {
      command: "loginctl terminate-user $USER"
      keybind: Qt.Key_L
      text: "Logout"
      icon: "system-log-out-symbolic"
    }

    LogoutButton {
      command: "systemctl suspend"
      keybind: Qt.Key_S
      text: "Suspend"
      icon: "system-suspend-symbolic"
    }

    LogoutButton {
      command: "systemctl hibernate"
      keybind: Qt.Key_H
      text: "Hibernate"
      icon: "system-suspend-hibernate-symbolic"
    }

    LogoutButton {
      command: "systemctl poweroff"
      keybind: Qt.Key_S
      shifted: true
      text: "Shutdown"
      icon: "system-shutdown-symbolic"
    }

    LogoutButton {
      command: "systemctl reboot"
      keybind: Qt.Key_R
      text: "Reboot"
      icon: "system-reboot-symbolic"
    }
  }
}
