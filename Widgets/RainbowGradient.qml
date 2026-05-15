import QtQuick
import QtQuick.Shapes
import qs.Commons

Item {
  id: root
  anchors.fill: parent

  property int animationDuration: Theme.animationSlowest
  property bool horizontal: true
  property int angle: 0
  property int index: 0

  readonly property list<color> colors: ["red", "orange", "yellow", "green", "blue", "green", "yellow", "orange"]
  readonly property int actualAngle: horizontal && angle === 0 ? 90 : angle
  readonly property real radians: actualAngle * Math.PI / 180
  readonly property real length: Math.abs(width * Math.sin(radians)) + Math.abs(height * Math.cos(radians))
  readonly property point center: Qt.point(width / 2, height / 2)
  readonly property point delta: Qt.point((Math.sin(radians) * length) / 2, (Math.cos(radians) * length) / 2)

  Timer {
    running: true
    interval: animationDuration
    repeat: true
    onTriggered: root.index++
  }

  LinearGradient {
    id: rainbowGradient
    x1: center.x - delta.x
    y1: center.y - delta.x
    x2: center.x + delta.x
    y2: center.y + delta.y

    GradientStop {
      position: 0.0
      color: root.colors[root.index % root.colors.length]
      Behavior on color {
        ColorAnimation {
          duration: root.animationDuration
        }
      }
    }
    GradientStop {
      position: 0.25
      color: root.colors[(root.index + 1) % root.colors.length]
      Behavior on color {
        ColorAnimation {
          duration: root.animationDuration
        }
      }
    }
    GradientStop {
      position: 0.5
      color: root.colors[(root.index + 2) % root.colors.length]
      Behavior on color {
        ColorAnimation {
          duration: root.animationDuration
        }
      }
    }
    GradientStop {
      position: 0.75
      color: root.colors[(root.index + 3) % root.colors.length]
      Behavior on color {
        ColorAnimation {
          duration: root.animationDuration
        }
      }
    }
    GradientStop {
      position: 1.0
      color: root.colors[(root.index + 4) % root.colors.length]
      Behavior on color {
        ColorAnimation {
          duration: root.animationDuration
        }
      }
    }
  }

  property alias gradient: rainbowGradient
}
