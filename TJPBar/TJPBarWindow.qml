import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Common

PanelWindow {
  id: barWindow

  property var modelData

  WlrLayershell.layer: WlrLayer.Top
  WlrLayershell.namespace: "tjp:bar"

  screen: modelData
  color: "transparent"
  implicitHeight: Theme.barHeight + Theme.spacing * 2
  implicitWidth: modelData.width

  anchors {
    top: true
    left: true
    right: true
    bottom: false
  }

  Item {
    id: contentItem
    anchors.fill: parent
    layer.enabled: true

    Rectangle {
      anchors.fill: parent
      anchors.topMargin: Theme.spacing
      anchors.leftMargin: Theme.spacing
      anchors.rightMargin: Theme.spacing
      anchors.bottomMargin: Theme.spacing
      color: Theme.base
      opacity: 0.8
      radius: Theme.radiusRound

      TJPBarContent {
        barWindow: barWindow
      }
    }
  }
}
