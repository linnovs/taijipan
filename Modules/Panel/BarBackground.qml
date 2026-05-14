import QtQuick
import QtQuick.Shapes
import Quickshell
import qs.Commons

ShapePath {
  id: root

  required property string section
  required property ShellScreen screen
  required property var bar

  readonly property var barSection: bar ? bar[`barSection${section}`] : null
  readonly property int barRadiusPadding: bar ? Theme.barRadius : 0

  readonly property bool enableRightCorner: section !== "Right"
  readonly property bool enableLeftCorner: section !== "Left"

  strokeWidth: -1

  startX: root.bar.x + root.barSection.x
  startY: root.bar.y + root.barSection.y

  // top edge
  PathLine {
    relativeX: root.barSection.width + (root.enableRightCorner ? root.barRadiusPadding * 2 : 0)
    relativeY: 0
  }

  // top-right corner
  PathArc {
    relativeX: root.enableRightCorner ? -root.barRadiusPadding : 0
    relativeY: root.enableRightCorner ? root.barRadiusPadding : 0
    radiusX: root.barRadiusPadding
    radiusY: root.barRadiusPadding
    direction: PathArc.Counterclockwise
  }

  // bottom-right corner
  PathArc {
    relativeX: root.enableRightCorner ? -root.barRadiusPadding : 0
    relativeY: root.enableRightCorner ? root.barRadiusPadding : 0
    radiusX: root.barRadiusPadding
    radiusY: root.barRadiusPadding
    direction: PathArc.Clockwise
  }

  // right edge
  PathLine {
    relativeX: 0
    relativeY: !root.enableRightCorner ? root.bar.height : 0
  }

  // bottom edge
  PathLine {
    relativeX: -root.barSection.width
    relativeY: 0
  }

  // bottom-left corner
  PathArc {
    relativeX: root.enableLeftCorner ? -root.barRadiusPadding : 0
    relativeY: root.enableLeftCorner ? -root.barRadiusPadding : 0
    radiusX: root.barRadiusPadding
    radiusY: root.barRadiusPadding
    direction: PathArc.Clockwise
  }

  // top-left corner
  PathArc {
    relativeX: root.enableLeftCorner ? -root.barRadiusPadding : 0
    relativeY: root.enableLeftCorner ? -root.barRadiusPadding : 0
    radiusX: root.barRadiusPadding
    radiusY: root.barRadiusPadding
    direction: PathArc.Counterclockwise
  }

  PathLine {
    x: startX
    y: startY
  }
}
