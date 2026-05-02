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

  readonly property bool isPanelOpenOnScreen: PanelService.openedPanel !== null && PanelService.openedPanel.screen === screen

  WlrLayershell.layer: WlrLayer.Top
  WlrLayershell.exclusionMode: ExclusionMode.Ignore
  WlrLayershell.namespace: "taijipan-panel-" + (screen?.name || "unknown")
  WlrLayershell.keyboardFocus: {
    if (!PanelService.isAnyPanelVisible) {
      return WlrKeyboardFocus.None;
    }

    if (root.isPanelOpenOnScreen) {
      return PanelService.openedPanel.exclusiveKeyboardFocus ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.OnDemand;
    }

    return WlrKeyboardFocus.OnDemand;
  }

  anchors.top: true
  anchors.right: true
  anchors.bottom: true
  anchors.left: true

  color: {
    if (PanelService.isAnyPanelVisible && PanelService.openedPanel.enableBackdrop) {
      return Qt.alpha(Colors.mShadow, Settings.data.general.dimmerOpacity || 0.8);
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
      width: PanelService.isAnyPanelVisible ? root.width : 0
      height: PanelService.isAnyPanelVisible ? root.height : 0
      intersection: Intersection.Subtract
    }

    regions: [barMaskRegion, panelMaskRegion]
  }

  Region {
    id: backdropRegion
    width: PanelService.isAnyPanelVisible && PanelService.openedPanel.enableBackdrop ? root.width : 0
    height: PanelService.isAnyPanelVisible && PanelService.openedPanel.enableBackdrop ? root.height : 0
  }
  BackgroundEffect.blurRegion: backdropRegion

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
    enabled: root.isPanelOpenOnScreen && !PanelService.isKeybindRecording
    onActivated: PanelService.onEscapePressed()
  }
}
