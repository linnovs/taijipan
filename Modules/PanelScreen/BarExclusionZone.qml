import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Commons

PanelWindow {
  id: root
  color: "transparent"
  mask: Region {}

  WlrLayershell.layer: WlrLayer.Top
  WlrLayershell.namespace: "taijipan-bar-exclusion-" + (screen?.name || "unknown")

  anchors.top: true
  anchors.left: true
  anchors.right: true

  implicitWidth: 0
  implicitHeight: Theme.barHeight

  Component.onCompleted: {
    Logger.d("BarExclusionZone", "Created for screen:", screen?.name);
  }
}
