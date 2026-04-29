import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.Commons

Item {
  id: root

  Layout.fillWidth: true
  Layout.preferredHeight: Theme.fontSizeMD + Theme.marginXS * 2

  property string currentUptime: ""

  Process {
    id: uptimeProcess
    command: ["uptime", "-p"]
    stdout: StdioCollector {
      onStreamFinished: root.currentUptime = text.trim().replace("up ", "")
    }
  }

  Timer {
    interval: 60 * 1000
    repeat: true
    running: true
    triggeredOnStart: true
    onTriggered: uptimeProcess.running = true
  }

  Text {
    anchors.centerIn: parent
    text: currentUptime
    color: Colors.mOnSurface
    font.pointSize: Theme.fontSizeMD
    font.weight: Font.DemiBold
  }
}
