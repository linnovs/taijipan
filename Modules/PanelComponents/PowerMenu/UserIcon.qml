import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.Commons

ClippingRectangle {
  Layout.alignment: Qt.AlignHCenter

  implicitWidth: Theme.powerMenuIconSize
  implicitHeight: Theme.powerMenuIconSize
  radius: Theme.radiusRound

  color: "transparent"

  Image {
    source: Settings.data.general.userIcon || Quickshell.shellPath("assets/default-user-icon.png")
    sourceSize: Qt.size(Theme.powerMenuIconSize, Theme.powerMenuIconSize)
  }
}
