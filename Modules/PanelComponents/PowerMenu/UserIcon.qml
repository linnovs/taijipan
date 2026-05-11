import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Widgets
import qs.Commons

Item {
  Layout.alignment: Qt.AlignHCenter
  implicitWidth: Theme.powerMenuIconSize
  implicitHeight: Theme.powerMenuIconSize

  RoundedImage {
    anchors.fill: parent
    source: Settings.data.general.userIcon || Quickshell.shellPath("assets/default-user-icon.png")
    sourceSize: Qt.size(Theme.powerMenuIconSize, Theme.powerMenuIconSize)
  }
}
