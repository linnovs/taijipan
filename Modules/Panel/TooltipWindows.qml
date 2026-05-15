import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Modules.Tooltip
import qs.Services
import qs.Commons

PanelWindow {
  id: root

  WlrLayershell.layer: WlrLayer.Top
  WlrLayershell.exclusionMode: ExclusionMode.Ignore
  WlrLayershell.namespace: "taijipan-tooltip-" + (screen?.name || "unknown")

  property int frameThickness: Theme.spacing * Settings.data.ui.frameThickness

  anchors.top: true
  anchors.left: true
  anchors.bottom: true
  anchors.right: true
  margins.top: frameThickness
  margins.left: frameThickness
  margins.bottom: frameThickness
  margins.right: frameThickness

  color: "transparent"
  mask: Region {}

  property ListModel tooltips: ListModel {}

  Loader {
    anchors.fill: parent
    active: tooltips.count > 0
    sourceComponent: Item {
      anchors.fill: parent

      Repeater {
        model: tooltips
        Tooltip {
          windowRoot: root
          title: model.title
          description: model.description
          position: Qt.point(model.positionX, model.positionY)
          isClosing: model.isClosing
          onClosed: tooltips.remove(index)
        }
      }
    }
  }

  Timer {
    id: tooltipCleanupTimer
    interval: Theme.timerDebounceLong
    repeat: true
    running: tooltips.count > 1
    onTriggered: {
      for (let i = tooltips.count - 1; i >= 1; i--)
        tooltips.setProperty(i, "isClosing", true);
    }
  }

  Connections {
    target: TooltipService
    function onShowTooltip(title, description, screenName, positionX, positionY) {
      if (screenName !== screen?.name)
        return;

      if (tooltips.count > 0) {
        tooltips.setProperty(0, "title", title);
        tooltips.setProperty(0, "description", description);
        tooltips.setProperty(0, "positionX", positionX);
        tooltips.setProperty(0, "positionY", positionY);
        return;
      }

      tooltips.append({
        title,
        description,
        screenName,
        positionX,
        positionY,
        isClosing: false
      });
    }
    function onHideTooltip(screenName) {
      if (screenName !== screen?.name)
        return;

      if (tooltips.count === 0)
        return;

      tooltips.setProperty(0, "isClosing", true);
    }
  }
}
