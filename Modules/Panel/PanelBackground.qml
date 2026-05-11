import QtQuick
import QtQuick.Shapes
import qs.Commons

ShapePath {
  id: root

  property var panel: null
  readonly property var panelRegion: panel?.panelRegion ?? null
  readonly property var panelBackground: (panelRegion && panelRegion.visible) ? panel.panelBackground : null
  readonly property real radius: panel ? panel.radius : 0

  readonly property real panelX: panelBackground ? panelBackground.x : 0
  readonly property real panelY: panelBackground ? panelBackground.y : 0
  readonly property real panelWidth: panelBackground ? panelBackground.width : 0
  readonly property real panelHeight: panelBackground ? panelBackground.height : 0
  readonly property bool isPanelVisible: panel && panelBackground && panelWidth > 0 && panelHeight > 0

  strokeWidth: -1
  capStyle: ShapePath.RoundCap

  startX: isPanelVisible ? panelX + radius : 0
  startY: isPanelVisible ? panelY : 0

  fillColor: isPanelVisible ? Colors.mSurface : "transparent"

  // top edge
  PathLine {
    relativeX: isPanelVisible ? panelWidth - radius * 2 : 0
    relativeY: 0
  }

  // top-right corner
  PathArc {
    relativeX: isPanelVisible ? radius : 0
    relativeY: isPanelVisible ? radius : 0
    radiusX: radius
    radiusY: radius
    direction: PathArc.Clockwise
  }

  // right edge
  PathLine {
    relativeX: 0
    relativeY: isPanelVisible ? panelHeight - radius * 2 : 0
  }

  // bottom-right corner
  PathArc {
    relativeX: isPanelVisible ? -radius : 0
    relativeY: isPanelVisible ? radius : 0
    radiusX: radius
    radiusY: radius
    direction: PathArc.Clockwise
  }

  // bottom edge
  PathLine {
    relativeX: isPanelVisible ? radius * 2 - panelWidth : 0
    relativeY: 0
  }

  // bottom-left corner
  PathArc {
    relativeX: isPanelVisible ? -radius : 0
    relativeY: isPanelVisible ? -radius : 0
    radiusX: radius
    radiusY: radius
    direction: PathArc.Clockwise
  }

  // left edge
  PathLine {
    relativeX: 0
    relativeY: isPanelVisible ? radius * 2 - panelHeight : 0
  }

  // top-left corner
  PathArc {
    relativeX: isPanelVisible ? radius : 0
    relativeY: isPanelVisible ? -radius : 0
    radiusX: radius
    radiusY: radius
    direction: PathArc.Clockwise
  }
}
