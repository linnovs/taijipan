import QtQuick
import QtQuick.Shapes
import Quickshell
import qs.Commons

ShapePath {
  id: root

  required property ShellScreen screen

  strokeWidth: -1

  // full screen
  PathRectangle {
    y: Theme.frameThickness + Theme.barHeight
    width: root.screen.width
    height: root.screen.height
  }

  // inner frame cutout
  PathRectangle {
    x: Theme.frameThickness
    y: Theme.frameThickness + Theme.barHeight
    width: root.screen.width - Theme.frameThickness * 2
    height: root.screen.height - Theme.barHeight - Theme.frameThickness * 2
    radius: Theme.barRadius
  }
}
