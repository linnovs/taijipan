import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import qs.Widgets
import qs.Commons

Item {
  id: root

  required property TextInput input
  required property LockContext context

  RowLayout {
    anchors.fill: parent
    anchors.bottom: parent.bottom

    Item {
      Layout.preferredWidth: Theme.marginXL
    }

    PasswordInput {
      id: passwordField
      Layout.fillWidth: true
      Layout.preferredHeight: Theme.marginXL
      input: root.input
      isError: context.isErrorMessage

      RainbowGradient {
        id: rainbowGradient
        angle: 45
      }

      Shape {
        anchors.centerIn: parent
        z: -1
        visible: context.isUnlocking
        ShapePath {
          fillGradient: rainbowGradient.gradient
          strokeWidth: -1
          PathRectangle {
            width: passwordField.width + 2
            height: passwordField.height + 2
            radius: Theme.radiusRound
          }
        }
      }
    }

    Item {
      Layout.preferredWidth: Theme.marginXL
    }
  }

  Connections {
    target: context
    function onFailed() {
      passwordField.failedAttempt();
    }
  }

  implicitWidth: Theme.widthMD
  implicitHeight: Theme.marginXL
}
