import QtQuick
import QtQuick.Shapes
import Quickshell
import qs.Commons

ShapePath {
  id: root

  required property string section
  required property ShellScreen screen
  required property int sectionWidth

  strokeWidth: -1

  readonly property int defaultBarHeight: Theme.spacing * (Settings.data.ui.bar.height - Settings.data.ui.bar.topMarginSpacing)
  readonly property int barHeight: sectionWidth > 0 ? defaultBarHeight : 0
  readonly property int barRadiusWidth: barHeight / 2
  readonly property int barRadiusHeight: barHeight / 2
  readonly property int barRadius: barHeight / 2
  readonly property int barExtraSpace: sectionWidth > 0 ? barRadiusWidth * 2 : 0

  readonly property int trMultX: section === "right" ? 0 : -1
  readonly property int trMultY: section === "right" ? 4 : 1
  readonly property int trRadius: section === "right" ? 0 : 1
  readonly property bool trClockwise: section === "right" ? false : false

  readonly property int brMultX: section === "right" ? -2 : -1
  readonly property int brMultY: section === "right" ? -2 : 1
  readonly property int brRadius: section === "right" ? 2 : 1
  readonly property bool brClockwise: section === "right" ? false : true

  readonly property int blMultX: section === "left" ? -2 : -1
  readonly property int blMultY: section === "left" ? 2 : -1
  readonly property int blRadius: section === "left" ? 2 : 1
  readonly property bool blClockwise: section === "left" ? false : true

  readonly property int tlMultX: section === "left" ? 0 : -1
  readonly property int tlMultY: section === "left" ? -4 : -1
  readonly property int tlRadius: section === "left" ? 0 : 1
  readonly property bool tlClockwise: section === "left" ? false : false

  readonly property int topEdgeLength: {
    switch (section) {
    case "left":
    case "right":
      return sectionWidth + barExtraSpace + barRadiusWidth * 2;
    case "center":
      return sectionWidth + barExtraSpace + barRadiusWidth * 4;
    }
  }
  readonly property int bottomEdgeLength: {
    switch (section) {
    case "left":
    case "right":
      return -sectionWidth - barExtraSpace + barRadiusWidth * 2;
    case "center":
      return -sectionWidth - barExtraSpace;
    }
  }

  readonly property int startPosX: {
    switch (section) {
    case "left":
      return 0;
    case "center":
      return screen.width / 2 - sectionWidth / 2 - barRadiusWidth * 2;
    case "right":
      return screen.width - sectionWidth - barRadiusWidth * 2;
    }
  }

  startX: startPosX
  startY: Theme.spacing * Settings.data.ui.bar.topMarginSpacing

  // top edge
  PathLine {
    relativeX: topEdgeLength
    relativeY: 0
  }

  // top-right corner
  PathArc {
    relativeX: barRadiusWidth * trMultX
    relativeY: barRadiusHeight * trMultY
    radiusX: barRadius * trRadius
    radiusY: barRadius * trRadius
    direction: trClockwise ? PathArc.Clockwise : PathArc.Counterclockwise
  }

  // top-left corner
  PathArc {
    relativeX: barRadiusWidth * brMultX
    relativeY: barRadiusHeight * brMultY
    radiusX: barRadius * brRadius
    radiusY: barRadius * brRadius
    direction: brClockwise ? PathArc.Clockwise : PathArc.Counterclockwise
  }

  // bottom edge
  PathLine {
    relativeX: bottomEdgeLength
    relativeY: 0
  }

  // bottom-left corner
  PathArc {
    relativeX: barRadiusWidth * blMultX
    relativeY: barRadiusHeight * blMultY
    radiusX: barRadius * blRadius
    radiusY: barRadius * blRadius
    direction: blClockwise ? PathArc.Clockwise : PathArc.Counterclockwise
  }

  // bottom-right corner
  PathArc {
    relativeX: barRadiusWidth * tlMultX
    relativeY: barRadiusHeight * tlMultY
    radiusX: barRadius * tlRadius
    radiusY: barRadius * tlRadius
    direction: tlClockwise ? PathArc.Clockwise : PathArc.Counterclockwise
  }

  // closing the path
  PathLine {
    x: root.startX
    y: root.startY
  }
}
