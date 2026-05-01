import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Modules.PanelComponents.PowerMenu
import qs.Services
import qs.Commons

PanelWindow {
  id: root

  Component.onCompleted: {
    Logger.d("PanelWindows", "Panel initialized for screen:", screen?.name, "- Dimensions:", screen?.width, "x", screen?.height, "- Position:", screen?.x, ",", screen?.y);
  }

  WlrLayershell.layer: WlrLayer.Top
  WlrLayershell.exclusionMode: ExclusionMode.Ignore
  WlrLayershell.namespace: "taijipan-panel-" + (screen?.name || "unknown")
  WlrLayershell.keyboardFocus: {
    if (!PanelService.isAnyPanelVisible) {
      return WlrKeyboardFocus.None;
    }

    if (PanelService.isPanelOpenOnScreen(screen)) {
      return PanelService.isPanelExclusiveKeyboardFocus() ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.OnDemand;
    }

    return WlrKeyboardFocus.OnDemand;
  }

  anchors.top: true
  anchors.right: true
  anchors.bottom: true
  anchors.left: true

  color: {
    if (PanelService.isAnyPanelVisible && PanelService.haveBackdrop()) {
      return Qt.alpha(Colors.mShadow, 0.8);
    }

    return "transparent";
  }
  mask: Region {
    id: clickableMask

    x: 0
    y: 0
    width: root.width
    height: root.height
    intersection: Intersection.Xor

    Region {
      id: barMaskRegion
      intersection: Intersection.Subtract
    }

    Region {
      id: panelMaskRegion
      x: 0
      y: 0
      width: PanelService.isAnyPanelVisible ? root.width : 0
      height: PanelService.isAnyPanelVisible ? root.height : 0
      intersection: Intersection.Subtract
    }

    regions: [barMaskRegion, panelMaskRegion]
  }

  Region {
    id: backdropRegion
    x: 0
    y: 0
    width: root.width
    height: root.height
  }
  BackgroundEffect.blurRegion: PanelService.isAnyPanelVisible && PanelService.haveBackdrop() ? backdropRegion : null

  Item {
    id: container
    width: root.width
    height: root.height

    Backgrounds {}

    MouseArea {
      anchors.fill: parent
      enabled: PanelService.isAnyPanelVisible
      acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
      onClicked: {
        if (PanelService.isAnyPanelVisible) {
          PanelService.closePanel();
        }
      }
      z: 0
    }

    PowerMenu {
      screen: root.screen
      objectName: "powerMenu-" + (root.screen?.name || "unknown")
      enableBackdrop: true
    }
  }

  Shortcut {
    sequences: ["Esc"]
    enabled: PanelService.isPanelOpenOnScreen(screen) && !PanelService.isKeybindRecording
    onActivated: PanelService.onEscapePressed()
  }
}
