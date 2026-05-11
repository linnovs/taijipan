import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Modules.PanelComponents.PowerMenu
import qs.Modules.PanelComponents.WallpaperSwitcher
import qs.Services
import qs.Commons

PanelWindow {
  id: root

  Component.onCompleted: {
    Logger.d("PanelWindows", "Panel initialized for screen:", screen?.name, "- Dimensions:", screen?.width, "x", screen?.height, "- Position:", screen?.x, ",", screen?.y);
  }

  readonly property bool isPanelOpenOnScreen: PanelService.openedPanel !== null && PanelService.openedPanel.screen === screen
  readonly property bool isPanelClosing: PanelService.openedPanel && PanelService.openedPanel.isClosing
  readonly property bool isAnyPanelVisible: PanelService.isAnyPanelVisible
  readonly property bool isCurrentPanelExclusive: PanelService.openedPanel && PanelService.openedPanel.exclusiveKeyboardFocus
  readonly property bool isBackdropEnabled: PanelService.isAnyPanelVisible && PanelService.openedPanel && PanelService.openedPanel.enableBackdrop

  WlrLayershell.layer: WlrLayer.Top
  WlrLayershell.exclusionMode: ExclusionMode.Ignore
  WlrLayershell.namespace: "taijipan-panel-" + (screen?.name || "unknown")
  WlrLayershell.keyboardFocus: {
    if (!root.isAnyPanelVisible) {
      return WlrKeyboardFocus.None;
    }

    if (root.isPanelOpenOnScreen) {
      return root.isCurrentPanelExclusive ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.OnDemand;
    }

    return WlrKeyboardFocus.OnDemand;
  }

  anchors.top: true
  anchors.right: true
  anchors.bottom: true
  anchors.left: true

  color: {
    if (root.isBackdropEnabled) {
      return Qt.alpha(Colors.mShadow, Settings.data.general.dimmerOpacity || 0.8);
    }

    return "transparent";
  }

  Behavior on color {
    ColorAnimation {
      duration: isPanelClosing ? Theme.animationFast : Theme.animationNormal
      easing.type: Easing.OutQuad
    }
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
      width: root.isAnyPanelVisible ? root.width : 0
      height: root.isAnyPanelVisible ? root.height : 0
      intersection: Intersection.Subtract
    }

    regions: [barMaskRegion, panelMaskRegion]
  }

  QtObject {
    id: backgroundBlur

    readonly property var panelBg: {
      let panel = PanelService.openedPanel;
      if (!panel || panel.screen !== root.screen)
        return null;
      let region = panel.panelRegion;
      return (region && region.visible) ? region : null;
    }
  }

  BackgroundEffect.blurRegion: Region {
    Region {
      x: backgroundBlur.panelBg ? backgroundBlur.panelBg.x : 0
      y: backgroundBlur.panelBg ? backgroundBlur.panelBg.y : 0
      width: backgroundBlur.panelBg ? backgroundBlur.panelBg.width : 0
      height: backgroundBlur.panelBg ? backgroundBlur.panelBg.height : 0
      radius: Theme.radiusLG
    }

    Region {
      width: root.isBackdropEnabled ? root.width : 0
      height: root.isBackdropEnabled ? root.height : 0
    }
  }

  Item {
    id: container
    width: root.width
    height: root.height

    Backgrounds {
      anchors.fill: parent
      windowRoot: root
      z: 0
    }

    MouseArea {
      anchors.fill: parent
      enabled: root.isAnyPanelVisible
      acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
      onClicked: {
        if (root.isAnyPanelVisible) {
          PanelService.closeOpenedPanel();
        }
      }
      z: 0
    }

    WallpaperSwitcher {
      screen: root.screen
      objectName: "wallpaperSwitcher-" + (root.screen?.name || "unknown")
    }

    PowerMenu {
      screen: root.screen
      objectName: "powerMenu-" + (root.screen?.name || "unknown")
      enableBackdrop: true
    }

    IdleInhibitor {
      window: root
      enabled: IdleInhibitorService.isIdleInhibited
    }
  }

  Shortcut {
    sequences: Settings.data.general.keybinds.esc || []
    enabled: root.isPanelOpenOnScreen && !PanelService.isKeybindRecording
    onActivated: PanelService.onEscapePressed()
  }

  Instantiator {
    model: Settings.data.general.keybinds.left || []
    Shortcut {
      sequence: modelData
      enabled: root.isPanelOpenOnScreen && (PanelService.openedPanel.onLeftPressed !== undefined) && !PanelService.isKeybindRecording
      onActivated: PanelService.openedPanel.onLeftPressed()
    }
  }

  Instantiator {
    model: Settings.data.general.keybinds.right || []
    Shortcut {
      sequence: modelData
      enabled: root.isPanelOpenOnScreen && (PanelService.openedPanel.onRightPressed !== undefined) && !PanelService.isKeybindRecording
      onActivated: PanelService.openedPanel.onRightPressed()
    }
  }

  Instantiator {
    model: Settings.data.general.keybinds.enter || []
    Shortcut {
      sequence: modelData
      enabled: root.isPanelOpenOnScreen && (PanelService.openedPanel.onEnterPressed !== undefined) && !PanelService.isKeybindRecording
      onActivated: PanelService.openedPanel.onEnterPressed()
    }
  }
}
