import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Modules.Bar
import qs.Services
import qs.Commons

PanelWindow { // qmllint disable
  id: barWindow
  color: "transparent"

  readonly property bool isPanelOpen: (PanelService.openedPanel !== null && PanelService.openedPanel.screen === screen)

  WlrLayershell.layer: WlrLayer.Top
  WlrLayershell.namespace: "taijipan-bar-" + (screen?.name || "unknown")
  WlrLayershell.exclusionMode: ExclusionMode.Ignore

  Component.onCompleted: {
    Logger.d("BarWindow", "BarWindow created for screen:", screen?.name);
  }

  anchors {
    top: true
    right: true
    bottom: false
    left: true
  }

  readonly property real barMarginH: screen?.width * Theme.barMarginHRatio || 0

  margins {
    top: 0
    right: barMarginH
    bottom: 0
    left: barMarginH
  }

  implicitWidth: screen?.width
  implicitHeight: Theme.barHeight

  Bar {
    anchors.fill: parent
    screen: barWindow.screen
  }
}
