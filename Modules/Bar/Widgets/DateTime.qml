import QtQuick
import Quickshell
import qs.Commons

Item {
  id: root

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  TextMetrics {
    id: datetimeMetrics
    font.family: Theme.fontFamily
    text: "ddd, dd MMM hh:mm:ss"
  }

  readonly property real contentWidth: datetimeMetrics.width + Theme.spacing * 2
  readonly property real contentHeight: Theme.barCapsuleHeight

  implicitWidth: contentWidth
  implicitHeight: contentHeight

  Rectangle {
    width: root.contentWidth
    height: root.contentHeight
    anchors.centerIn: parent
    color: Theme.barCapsuleColor
    radius: Theme.radiusL

    Text {
      anchors.centerIn: parent
      text: Qt.formatDateTime(clock.date, "ddd, dd MMM hh:mm:ss")
      color: Theme.barCapsuleTextColor
    }
  }
}
