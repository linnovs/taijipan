import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons

Item {
  FontLoader {
    id: anuratiFont
    source: Quickshell.shellPath("assets/fonts/Anurati/Anurati-Regular.otf")
  }

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

  ColumnLayout {
    id: clockLayout

    anchors.horizontalCenter: parent.horizontalCenter

    Text {
      id: weekdayText
      Layout.alignment: Qt.AlignHCenter
      font.family: anuratiFont.name
      font.pointSize: Theme.fontSize4XL
      font.letterSpacing: Theme.marginMD
      font.weight: Font.Bold
      color: Colors.mOnSurface
      text: Time.format(clock.date, "dddd").toUpperCase()
    }

    Text {
      id: dateText
      Layout.alignment: Qt.AlignHCenter
      font.family: Settings.data.ui.font
      font.pointSize: Theme.fontSizeMD
      font.letterSpacing: Theme.spacing
      font.weight: Font.DemiBold
      color: Colors.mOnSurface
      text: Time.format(clock.date, "dd MMMM yyyy").toUpperCase()
    }

    Text {
      id: timeText
      Layout.alignment: Qt.AlignHCenter
      font.family: Settings.data.ui.font
      font.pointSize: Theme.fontSizeMD
      font.letterSpacing: Theme.spacing
      font.weight: Font.DemiBold
      color: Colors.mOnSurface
      text: Time.format(clock.date, "- HH:mm -")
    }
  }

  implicitWidth: clockLayout.implicitWidth
  implicitHeight: clockLayout.implicitHeight
}
