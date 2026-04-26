import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Commons

PanelWindow {
  id: root

  WlrLayershell.layer: WlrLayer.Top
  WlrLayershell.exclusionMode: ExclusionMode.Auto
  WlrLayershell.namespace: "taijipan-bar-exclusion-" + (screen?.name || "unknown")

  anchors.top: true
  anchors.left: true
  anchors.right: true

  color: "transparent"
  mask: Region {}

  // We want the width to be determined by the screen width, so we set it to 0 and let the anchors handle it.
  implicitWidth: 0
  implicitHeight: Theme.barHeight + Theme.barMarginV
}
