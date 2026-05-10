import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.Commons

Item {
  id: root

  property string username: "unknown"

  Process {
    id: whoamiProcess
    command: ["whoami"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: root.username = text.trim()
    }
  }

  RowLayout {
    anchors.fill: parent
    anchors.bottom: parent.bottom

    Item {
      Layout.preferredWidth: Theme.marginXL
    }

    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: Theme.marginXL
      color: Colors.mSurface
      radius: Theme.radiusRound
      border.color: Colors.mOutline
      border.width: 1

      Text {
        anchors.centerIn: parent
        text: root.username
        color: Qt.alpha(Colors.mOnSurface, 0.8)
      }
    }

    Item {
      Layout.preferredWidth: Theme.marginXL
    }
  }

  implicitWidth: Theme.widthMD
  implicitHeight: Theme.marginXL
}
