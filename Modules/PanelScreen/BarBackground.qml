import QtQuick
import QtQuick.Shapes
import qs.Commons

ShapePath {
  id: root

  required property var barRef
  required property var windowRef
  required property var shapeContainer

  readonly property point barPos: barRef ? Qt.point(barRef.x, barRef.y) : Qt.point(0, 0)
  readonly property real barWidth: barRef ? barRef.width : 0
  readonly property real barHeight: barRef ? barRef.height : 0

  readonly property real tlMarginX: -barHeight * 0.75
  readonly property real tlMarginY: 0
  readonly property real tlRadius: 0

  readonly property real trMarginX: barHeight * 0.75
  readonly property real trMarginY: 0
  readonly property real trRadius: barHeight / 2

  readonly property real brMarginX: -barHeight * 0.25
  readonly property real brMarginY: 0
  readonly property real brRadius: barHeight / 2

  readonly property real blMarginX: barHeight * 0.25
  readonly property real blMarginY: barHeight / 2
  readonly property real blRadius: barHeight / 2

  strokeWidth: -1
  fillColor: Colors.mBackground
  fillRule: ShapePath.WindingFill

  startX: root.barPos.x + root.tlMarginX
  startY: root.barPos.y + root.tlMarginY

  PathLine {
    x: root.barPos.x + root.barWidth + root.trMarginX
    y: root.barPos.y + root.trMarginY
  }

  PathArc {
    x: root.barPos.x + root.barWidth + root.barHeight - root.trMarginX
    y: root.barPos.y + root.trMarginY + root.trRadius
    radiusX: root.trRadius; radiusY: root.trRadius
    direction: PathArc.Counterclockwise
  }

  PathArc {
    x: root.barPos.x + root.barWidth + root.brMarginX
    y: root.barPos.y + root.barHeight + root.brMarginY
    radiusX: root.brRadius; radiusY: root.brRadius
  }

  PathLine {
    x: root.barPos.x + root.blMarginX
    y: root.barPos.y + root.barHeight
  }

  PathArc {
    x: root.barPos.x - root.blMarginX
    y: root.barPos.y + root.blMarginY
    radiusX: root.blRadius; radiusY: root.blRadius
  }

  PathArc {
    x: root.barPos.x + root.tlMarginX
    y: root.barPos.y + root.tlMarginY
    radiusX: root.blRadius; radiusY: root.blRadius
    direction: PathArc.Counterclockwise
  }
}
