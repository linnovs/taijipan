import QtQuick
import Quickshell
import Quickshell.Wayland
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

  color: "transparent"
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
  }

  Item {
    id: container
    width: root.width
    height: root.height
  }
}
