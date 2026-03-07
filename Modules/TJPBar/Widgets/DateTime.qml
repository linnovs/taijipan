import QtQuick
import Quickshell
import qs.Commons

Item {
  id: dateTime

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  implicitWidth: childrenRect.width
  implicitHeight: Theme.barItemHeight

  Text {
    anchors.verticalCenter: parent.verticalCenter
    height: dateTime.height

    text: Qt.formatDateTime(clock.date, "ddd, dd MMM hh:mm:ss")
    color: Theme.text
  }
}
