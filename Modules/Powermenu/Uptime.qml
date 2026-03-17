import QtQuick
import Quickshell.Io
import qs.Commons

Item {
  id: root

  property string currentUptime

  implicitWidth: childrenRect.width
  implicitHeight: childrenRect.height

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

  Rectangle {
    color: Theme.mantle
    opacity: 0.85
    radius: Theme.radiusM
    implicitHeight: uptimeText.implicitHeight + Theme.spacing * 2
    implicitWidth: uptimeText.implicitWidth + Theme.spacing * 24

    Text {
      id: uptimeText
      anchors.centerIn: parent
      color: Theme.text
      text: "System | Uptime: " + root.currentUptime
    }
  }
}
