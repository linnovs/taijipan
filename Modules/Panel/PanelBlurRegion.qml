import QtQuick
import Quickshell
import qs.Services
import qs.Commons

Item {
  id: root
  anchors.fill: parent

  required property ShellScreen screen
  required property bool isBackdropEnabled

  QtObject {
    id: backgroundBlur

    readonly property var frameRegion: ({
        x: Theme.frameThickness,
        y: Theme.frameThickness + Theme.barHeight,
        width: root.width - Theme.frameThickness * 2,
        height: root.height - Theme.barHeight - Theme.frameThickness * 2
      })

    readonly property var panelBg: {
      let panel = PanelService.openedPanel;
      if (!panel || panel.screen !== root.screen)
        return null;
      let region = panel.panelRegion;
      return (region && region.visible) ? panel.panelBackground : null;
    }

    readonly property var closingPanelBg: {
      let panel = PanelService.closingPanel;
      if (!panel || panel.screen !== root.screen)
        return null;
      let region = panel.panelRegion;
      return (region && region.visible) ? region : null;
    }
  }

  Region {
    id: blurRegion
    // frame blur
    Region {
      x: 0
      y: backgroundBlur.frameRegion.y
      width: root.width
      height: root.height
      Region {
        x: backgroundBlur.frameRegion.x
        y: backgroundBlur.frameRegion.y
        width: backgroundBlur.frameRegion.width
        height: backgroundBlur.frameRegion.height
        intersection: Intersection.Subtract
        radius: Theme.barRadius
      }
    }

    Region {
      x: backgroundBlur.panelBg ? backgroundBlur.panelBg.x : 0
      y: backgroundBlur.panelBg ? backgroundBlur.panelBg.y : 0
      width: backgroundBlur.panelBg ? backgroundBlur.panelBg.width : 0
      height: backgroundBlur.panelBg ? backgroundBlur.panelBg.height : 0
      radius: backgroundBlur.panelBg ? backgroundBlur.panelBg.radius : Theme.radiusLG
    }

    Region {
      x: backgroundBlur.closingPanelBg ? backgroundBlur.closingPanelBg.x : 0
      y: backgroundBlur.closingPanelBg ? backgroundBlur.closingPanelBg.y : 0
      width: backgroundBlur.closingPanelBg ? backgroundBlur.closingPanelBg.width : 0
      height: backgroundBlur.closingPanelBg ? backgroundBlur.closingPanelBg.height : 0
      radius: backgroundBlur.closingPanelBg ? backgroundBlur.closingPanelBg.radius : Theme.radiusLG
    }

    Region {
      x: 0
      y: 0
      width: root.isBackdropEnabled ? root.width : 0
      height: root.isBackdropEnabled ? root.height : 0
    }
  }

  property alias region: blurRegion
}
