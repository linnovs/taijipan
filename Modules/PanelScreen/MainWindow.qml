import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Services
import qs.Commons

PanelWindow {
  id: root

  WlrLayershell.layer: WlrLayer.Top
  WlrLayershell.namespace: "taijipan-panelscreen-" + (screen?.name || "unknown")
  WlrLayershell.exclusionMode: ExclusionMode.Ignore

  Component.onCompleted: {
    Logger.d("MainWindow", "Window created for screen:", screen?.name, "- Dimensions:", screen?.width, "x", screen?.height);
  }

  anchors {
    top: true
    right: true
    bottom: true
    left: true
  }

  property bool isPanelOpen: (PanelService.openedPanel !== null && PanelService.openedPanel.screen === screen)
  property bool isAnyPanelOpen: (PanelService.openedPanel !== null)

  color: {
    if (isAnyPanelOpen) {
      return Qt.alpha(Theme.surface, 0.9);
    }
    return "transparent";
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
  }
}
