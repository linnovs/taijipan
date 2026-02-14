import QtQuick
import Quickshell
import qs.Common

Item {
  id: dateTime

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  width: childrenRect.width

  Text {
    anchors.verticalCenter: parent.verticalCenter

    text: Qt.formatDateTime(clock.date, "ddd, dd MMM hh:mm:ss")
    color: Theme.text
  }
}
