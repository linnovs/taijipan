import QtQuick
import QtQuick.Shapes
import qs.Widgets

Item {
  id: root

  required property var barRef
  required property var windowRef

  anchors.fill: parent

  Item {
    anchors.fill: parent

    Item {
      anchors.fill: parent
      layer.enabled: true
      opacity: 0.9

      Shape {
        id: barBackgroundShape
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer
        enabled: false

        BarBackground {
          barRef: root.barRef
          windowRef: root.windowRef
          shapeContainer: barBackgroundShape
        }
      }

      DropShadow {
        anchors.fill: parent
        source: barBackgroundShape
      }
    }
  }
}
