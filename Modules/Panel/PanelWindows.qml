import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Commons

PanelWindow {
  id: root

  WlrLayershell.layer: WlrLayer.Top
  WlrLayershell.exclusiveZone: ExclusionMode.Ignore
  WlrLayershell.namespace: "taijipan-panel-" + (screen?.name || "unknown")

  mask: Region {}
  color: "transparent"

  Component.onCompleted: {
    Logger.d("PanelWindows", "Panel initialized for screen:", screen?.name, "- Dimensions:", screen?.width, "x", screen?.height, "- Position:", screen?.x + "," + screen?.y);
  }
}
