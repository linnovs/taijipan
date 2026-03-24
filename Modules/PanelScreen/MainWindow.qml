import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Modules.Panels.Powermenu
import qs.Services
import qs.Commons

PanelWindow { // qmllint disable
  id: root

  property bool isPanelOpen: (PanelService.openedPanel !== null && PanelService.openedPanel.screen === screen)
  property bool isAnyPanelOpen: (PanelService.openedPanel !== null)

  WlrLayershell.layer: WlrLayer.Top
  WlrLayershell.namespace: "taijipan-panelscreen-" + (screen?.name || "unknown")
  WlrLayershell.exclusionMode: ExclusionMode.Ignore
  WlrLayershell.keyboardFocus: {
    if (!root.isAnyPanelOpen) return WlrKeyboardFocus.None;

    if (root.isPanelOpen) {
      return PanelService.openedPanel.exclusiveKeyboard ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.OnDemand;
    }

    return WlrKeyboardFocus.OnDemand
  }

  Component.onCompleted: {
    Logger.d("MainWindow", "Window created for screen:", screen?.name, "- Dimensions:", screen?.width, "x", screen?.height);
  }

  anchors {
    top: true
    right: true
    bottom: true
    left: true
  }

  color: {
    if (isAnyPanelOpen) {
      return Qt.alpha(Theme.surface, 0.9);
    }
    return "transparent";
  }

  Behavior on color {
    ColorAnimation {
      duration: Theme.animationNormal
      easing.type: Easing.InOutQuad
    }
  }

  mask: Region {
    id: clickthroughMask
    x: 0; y: 0; width: root.width; height: root.height
    intersection: Intersection.Xor

    Region {
      x: 0; y: 0
      width: root.width;
      height: Theme.barHeight
      intersection: Intersection.Subtract
    }

    Region {
      x: 0; y: 0;
      width: root.isAnyPanelOpen ? root.width : 0;
      height: root.isAnyPanelOpen ? root.height : 0
      intersection: Intersection.Subtract
    }
  }

  Item {
    id: container
    width: root.width
    height: root.height

    Background {
      anchors.fill: parent
      barRef: barPlaceholder.barItem || null
      windowRef: root
      z: 0
    }

    MouseArea {
      anchors.fill: parent
      enabled: root.isAnyPanelOpen
      acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
      z: 0
      onClicked: {
        if (PanelService.openedPanel) {
          PanelService.openedPanel.close();
        }
      }
    }

    Powermenu {
      id: powermenuPanel
      objectName: "powermenu-" + (root.screen?.name || "unknown")
      screen: root.screen
    }

    Item {
      id: barPlaceholder
      readonly property var barItem: barPlaceholder
      property ShellScreen screen: root.screen
      x: root.width * 0.1; y: 0
      width: root.width - root.width * 0.2
      height: Theme.barHeight
    }
  }

  Shortcut {
    sequence: "Esc"
    enabled: root.isPanelOpen && (PanelService.openedPanel.onEscapePressed !== undefined)
    onActivated: PanelService.openedPanel.onEscapePressed()
  }
}
