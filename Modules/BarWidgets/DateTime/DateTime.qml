import QtQuick
import Quickshell
import qs.Widgets
import qs.Commons

BaseBarWidget {
  id: root

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  widgetSource: Text {
    font.family: Settings.data.ui.font
    font.pointSize: Settings.data.ui.bar.fontSize
    font.weight: Font.Medium
    text: Qt.formatDateTime(clock.date, "ddd d MMM hh:mm:ss")
    color: Colors.mOnSurface
  }
}
