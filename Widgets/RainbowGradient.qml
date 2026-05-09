import QtQuick

Item {
  id: root
  property int animationDuration: 700
  property int index: 0

  readonly property list<color> colors: ["red", "orange", "yellow", "green", "blue", "green", "yellow", "orange"]

  Timer {
    running: true
    interval: animationDuration
    repeat: true
    onTriggered: root.index++
  }

  Gradient {
    id: rainbowGradient
    orientation: Gradient.Horizontal
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
