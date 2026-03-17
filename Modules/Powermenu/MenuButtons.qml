pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Widgets
import qs.Commons

RowLayout {
  id: root
  spacing: Theme.spacing * 4

  signal commandExecuted

  Repeater {
    model: [
      {command: "swaylock", icon: "lockscreen"},
      {command: "loginctl terminate-user $USER", icon: "logout"},
      {command: "systemctl suspend", icon: "suspend"},
      {command: "systemctl hibernate", icon: "hibernate"},
      {command: "systemctl poweroff", icon: "shutdown"},
      {command: "systemctl reboot", icon: "reboot"},
    ]

    delegate: Rectangle {
      id: buttonContainer
      required property var modelData

      implicitWidth: Theme.powermenuButtonSize
      implicitHeight: Theme.powermenuButtonSize
      color: buttonMa.containsMouse ? Theme.mauve : Theme.mantle

      ColorImageIcon {
        name: `${Quickshell.shellDir}/assets/icons/${buttonContainer.modelData.icon}.png`
        anchors.centerIn: parent
        implicitHeight: parent.height * 0.5
        implicitWidth: parent.width * 0.5
        color: buttonMa.containsMouse ? Theme.base : Theme.text
      }

      Process {
        id: buttonProcess
        command: ["sh", "-c", buttonContainer.modelData.command]
      }

      MouseArea {
        id: buttonMa
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
          buttonProcess.startDetached();
          root.commandExecuted();
        }
      }
    }
  }
}
