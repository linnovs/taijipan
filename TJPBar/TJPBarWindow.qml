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
  color: Theme.base
  implicitHeight: Theme.barHeight
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

    TJPBarContent {
      barWindow: barWindow
    }
  }
}
