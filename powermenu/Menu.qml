pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Variants {
  id: root

  signal close()
  property color backgroundColor: "#e61e1e2e"
  property color buttonColor: "#1e1e2e"
  property color buttonHoverColor: "#cba6f7"
  default property list<LogoutButton> buttons

  model: Quickshell.screens

  PanelWindow {
    id: w

    property var modelData
    screen: modelData

    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    color: "transparent"

    contentItem {
      focus: true
      Keys.onPressed: event => {
        if (event.key == Qt.Key_Escape) root.close();
        else {
          for (let i = 0; i < root.buttons.length; i++) {
            let button = root.buttons[i];
            if (button.shifted && !(event.modifiers & Qt.ShiftModifier)) continue;
            if (event.key == button.keybind) { button.exec(); root.close() };
          }
        }
      }
    }

    anchors {
      top: true
      left: true
      bottom: true
      right: true
    }

    Rectangle {
      color: root.backgroundColor;
      anchors.fill: parent

      MouseArea {
        anchors.fill: parent
        onClicked: root.close()

        GridLayout {
          anchors.centerIn: parent

          width: parent.width * 0.75
          height: parent.height * 0.75

          columns: 3
          columnSpacing: 0
          rowSpacing: 0

          Repeater {
            model: root.buttons

            delegate: Rectangle {
              id: button
              required property LogoutButton modelData;

              Layout.fillWidth: true
              Layout.fillHeight: true

              color: ma.containsMouse ? root.buttonHoverColor : root.buttonColor
              border.color: "#11111b"
              border.width: ma.containsMouse ? 0 : 1

              MouseArea {
                id: ma
                anchors.fill: parent
                hoverEnabled: true
                onClicked: { button.modelData.exec(); root.close() }
              }

              Image {
                id: icon
                anchors.centerIn: parent
                source: `icons/${button.modelData.icon}.png`
                width: parent.width * 0.25
                height: parent.width * 0.25
              }

              Text {
                anchors {
                  top: icon.bottom
                  topMargin: 20
                  horizontalCenter: parent.horizontalCenter
                }

                text: button.modelData.text
                font.pointSize: 20
                color: "#cdd6f4"
              }
            }
          }
        }
      }
    }
  }
}
