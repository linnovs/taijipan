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
  readonly property int frameThickness: Theme.spacing * Settings.data.ui.frameThickness

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

  Item {
    id: barPlaceholder

    property int barSectionPadding: Theme.spacing * Settings.data.ui.bar.sectionPadding

    property int barContentWidthLeft: 0
    property int barContentWidthCenter: 0
    property int barContentWidthRight: 0

    x: root.frameThickness
    y: root.frameThickness
    width: screen ? screen.width - root.frameThickness * 2 : 0
    height: Settings.data.ui.bar.height * Theme.spacing

    Item {
      id: barLeftSectionPlaceholder
      width: barPlaceholder.barContentWidthLeft + barPlaceholder.barSectionPadding * 2
      height: barPlaceholder.height
    }
    property alias barSectionLeft: barLeftSectionPlaceholder

    Item {
      id: barCenterSectionPlaceholder
      x: Theme.pixelAlignCenter(barPlaceholder.width, width)
      width: barPlaceholder.barContentWidthCenter + barPlaceholder.barSectionPadding * 2
      height: barPlaceholder.height
    }
    property alias barSectionCenter: barCenterSectionPlaceholder

    Item {
      id: barRightSectionPlaceholder
      x: barPlaceholder.width - width
      width: barPlaceholder.barContentWidthRight + barPlaceholder.barSectionPadding * 2
      height: barPlaceholder.height
    }
    property alias barSectionRight: barRightSectionPlaceholder

    Connections {
      target: BarService
      function onSectionSizeChanged(screenName, section, width) {
        if (screenName !== screen.name)
          return;
        const propName = {
          left: "barContentWidthLeft",
          center: "barContentWidthCenter",
          right: "barContentWidthRight"
        }[section];
        if (barPlaceholder.hasOwnProperty(propName))
          barPlaceholder[propName] = width;
      }
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
      x: barPlaceholder.x
      y: barPlaceholder.y
      width: barPlaceholder.width
      height: barPlaceholder.height
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

    readonly property var barBg: ({
        leftSection: {
          x: 0,
          width: barPlaceholder.x + barPlaceholder.barSectionLeft.width + Theme.barRadius,
          height: barPlaceholder.y + barPlaceholder.barSectionLeft.height
        },
        leftCenterGap: {
          x: barPlaceholder.x + barPlaceholder.barSectionLeft.width + Theme.barRadius,
          y: root.frameThickness,
          width: barPlaceholder.barSectionCenter.x - barPlaceholder.barSectionCenter.width - Theme.barRadius * 2,
          height: barPlaceholder.height + root.frameThickness
        },
        centerSection: {
          x: barPlaceholder.x + barPlaceholder.barSectionCenter.x - Theme.barRadius,
          width: barPlaceholder.barSectionCenter.width + Theme.barRadius * 2,
          height: barPlaceholder.y + barPlaceholder.barSectionCenter.height
        },
        centerRightGap: {
          x: barPlaceholder.x + barPlaceholder.barSectionCenter.x + barPlaceholder.barSectionCenter.width + Theme.barRadius,
          y: root.frameThickness,
          width: barPlaceholder.barSectionRight.x - barPlaceholder.barSectionCenter.x - barPlaceholder.barSectionCenter.width - Theme.barRadius * 2,
          height: barPlaceholder.height + root.frameThickness
        },
        rightSection: {
          x: barPlaceholder.x + barPlaceholder.barSectionRight.x - Theme.barRadius,
          width: barPlaceholder.barSectionRight.width + root.frameThickness + Theme.barRadius,
          height: barPlaceholder.y + barPlaceholder.barSectionRight.height
        }
      })

    readonly property var frameRegion: ({
        x: root.frameThickness,
        y: root.frameThickness + barPlaceholder.height,
        width: root.width - root.frameThickness * 2,
        height: root.height - barPlaceholder.height - root.frameThickness * 2
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

  BackgroundEffect.blurRegion: Region {
    // bar bar
    Region {
      Region {
        x: backgroundBlur.barBg.leftSection.x
        width: backgroundBlur.barBg.leftSection.width
        height: backgroundBlur.barBg.leftSection.height
        bottomRightRadius: Theme.barRadius
      }
      Region {
        x: backgroundBlur.barBg.leftCenterGap.x
        width: backgroundBlur.barBg.leftCenterGap.width
        height: backgroundBlur.barBg.leftCenterGap.height
        Region {
          x: backgroundBlur.barBg.leftCenterGap.x
          y: backgroundBlur.barBg.leftCenterGap.y
          width: backgroundBlur.barBg.leftCenterGap.width
          height: backgroundBlur.barBg.leftCenterGap.height
          topLeftRadius: Theme.barRadius
          topRightRadius: Theme.barRadius
          intersection: Intersection.Subtract
        }
      }
      Region {
        x: backgroundBlur.barBg.centerSection.x
        width: backgroundBlur.barBg.centerSection.width
        height: backgroundBlur.barBg.centerSection.height
        bottomLeftRadius: Theme.barRadius
        bottomRightRadius: Theme.barRadius
      }
      Region {
        x: backgroundBlur.barBg.centerRightGap.x
        width: backgroundBlur.barBg.centerRightGap.width
        height: backgroundBlur.barBg.centerRightGap.height
        Region {
          x: backgroundBlur.barBg.centerRightGap.x
          y: backgroundBlur.barBg.centerRightGap.y
          width: backgroundBlur.barBg.centerRightGap.width
          height: backgroundBlur.barBg.centerRightGap.height
          topLeftRadius: Theme.barRadius
          topRightRadius: Theme.barRadius
          intersection: Intersection.Subtract
        }
      }
      Region {
        x: backgroundBlur.barBg.rightSection.x
        width: backgroundBlur.barBg.rightSection.width
        height: backgroundBlur.barBg.rightSection.height
        bottomLeftRadius: Theme.barRadius
      }
    }

    // frame blur
    Region {
      y: barPlaceholder.y + barPlaceholder.height
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

  Item {
    id: container
    width: root.width
    height: root.height

    Backgrounds {
      anchors.fill: parent
      bar: barPlaceholder
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
