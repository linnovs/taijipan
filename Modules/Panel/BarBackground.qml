import QtQuick
import QtQuick.Shapes
import Quickshell
import qs.Services
import qs.Commons

ShapePath {
  id: root

  required property string section
  required property ShellScreen screen

  strokeWidth: -1

  property real sectionWidth: BarService.getSectionWidth(screen.name, section)
  property real defaultBarHeight: Theme.spacing * (Settings.data.ui.bar.height - Settings.data.ui.bar.topMarginSpacing)
  property real barHeight: sectionWidth > 0 ? defaultBarHeight : 0
  property real barRadiusWidth: barHeight / 2
  property real barRadiusHeight: barHeight / 2
  property real barRadius: barHeight / 2

  property real trMultX: section === "right" ? 0 : -1
  property real trMultY: section === "right" ? 4 : 1
  property real trRadius: section === "right" ? 0 : 1
  property bool trClockwise: section === "right" ? false : false

  property real brMultX: section === "right" ? -2 : -1
  property real brMultY: section === "right" ? -2 : 1
  property real brRadius: section === "right" ? 2 : 1
  property bool brClockwise: section === "right" ? false : true

  property real blMultX: section === "left" ? -2 : -1
  property real blMultY: section === "left" ? 2 : -1
  property real blRadius: section === "left" ? 2 : 1
  property bool blClockwise: section === "left" ? false : true

  property real tlMultX: section === "left" ? 0 : -1
  property real tlMultY: section === "left" ? -4 : -1
  property real tlRadius: section === "left" ? 0 : 1
  property bool tlClockwise: section === "left" ? false : false

  property real topEdgeLength: {
    switch (section) {
    case "left":
    case "right":
      return sectionWidth + barRadiusWidth * 2;
    case "center":
      return sectionWidth + barRadiusWidth * 4;
    }
  }
  property real bottomEdgeLength: {
    switch (section) {
    case "left":
    case "right":
      return -sectionWidth + barRadiusWidth * 2;
    case "center":
      return -sectionWidth;
    }
  }

  startX: {
    switch (section) {
    case "left":
      return 0;
    case "center":
      return screen.width / 2 - sectionWidth / 2 - barRadiusWidth * 2;
    case "right":
      return screen.width - sectionWidth - barRadiusWidth * 2;
    }
  }
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
