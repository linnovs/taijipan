import QtQuick
import QtQuick.Shapes
import Quickshell
import qs.Commons

ShapePath {
  id: root

  required property ShellScreen screen

  readonly property int thickness: Theme.spacing * Settings.data.ui.frameThickness
  readonly property int barHeight: Theme.spacing * Settings.data.ui.bar.height

  strokeWidth: -1

  // full screen
  PathRectangle {
    y: thickness + barHeight
    width: root.screen.width
    height: root.screen.height
  }

  // inner frame cutout
  PathRectangle {
    x: root.thickness
    y: root.thickness + root.barHeight
    width: root.screen.width - root.thickness * 2
    height: root.screen.height - root.barHeight - root.thickness * 2
    radius: Theme.barRadius
  }
}
