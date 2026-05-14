import QtQuick
import QtQuick.Shapes
import Quickshell
import qs.Commons

ShapePath {
  id: root

  required property ShellScreen screen

  readonly property int topEdgeMargin: Theme.spacing * Settings.data.ui.bar.topMargin
  readonly property int leftEdgeMargin: Theme.spacing * Settings.data.ui.bar.leftMargin
  readonly property int bottomEdgeMargin: Theme.spacing * Settings.data.ui.bar.bottomMargin
  readonly property int rightEdgeMargin: Theme.spacing * Settings.data.ui.bar.rightMargin
  readonly property int innerBorderRadius: Theme.spacing * Settings.data.ui.bar.height / 2

  strokeWidth: -1

  // inner shape which is the cutout area
  PathRectangle {
    x: leftEdgeMargin
    y: topEdgeMargin
    width: screen.width - leftEdgeMargin - rightEdgeMargin
    height: screen.height - topEdgeMargin - bottomEdgeMargin
    radius: innerBorderRadius
    topLeftRadius: 0
    topRightRadius: 0
  }

  // outer shape which is the full area of the screen
  PathRectangle {
    width: screen.width
    height: screen.height
  }
}
