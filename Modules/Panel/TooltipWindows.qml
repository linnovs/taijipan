import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Modules.Tooltip
import qs.Services
import qs.Commons

PanelWindow {
  id: root

  WlrLayershell.layer: WlrLayer.Top
  WlrLayershell.exclusionMode: ExclusionMode.Ignore
  WlrLayershell.namespace: "taijipan-tooltip-" + (screen?.name || "unknown")

  property int frameThickness: Theme.spacing * Settings.data.ui.frameThickness

  anchors.top: true
  anchors.left: true
  anchors.bottom: true
  anchors.right: true

  color: "transparent"
  mask: Region {}

  property ListModel tooltips: TooltipService.tooltips

  Loader {
    anchors.fill: parent
    anchors.topMargin: frameThickness
    anchors.leftMargin: frameThickness
    anchors.bottomMargin: frameThickness
    anchors.rightMargin: frameThickness
    active: tooltips.count > 0
    sourceComponent: Item {
      anchors.fill: parent

      Repeater {
        model: tooltips
        anchors.fill: parent
        Loader {
          active: model.screenName === root.screen.name
          sourceComponent: Tooltip {
            windowRoot: root
            title: model.title
            description: model.description
            position: Qt.point(model.positionX, model.positionY)
            isClosing: model.isClosing
            onClosed: tooltips.remove(index)
          }
        }
      }
    }
  }
}
