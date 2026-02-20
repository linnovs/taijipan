pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Variants {
  id: root

  required property string uptimeText
  default property list<LogoutButton> buttons

  signal close()
  property color backgroundColor: "#e61e1e2e"
  property color paneColor: "#11111b"
  property color textBarColor: "#313244"
  property color buttonColor: "#1e1e2e"
  property color buttonHoverColor: "#cba6f7"
  readonly property color textColor: "#cdd6f4"

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
            let shifted = !!(event.modifiers & Qt.ShiftModifier);
            let matched = event.key == button.keybind;

            if (button.shifted == shifted && matched) { button.exec(); root.close() };
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

        Rectangle {
          anchors.centerIn: parent
          width: parent.width * 0.4
          height: parent.height * 0.2
          color: root.paneColor

          ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20

            RowLayout {
              Layout.fillWidth: true
              Layout.fillHeight: false
              Layout.preferredHeight: parent.height * 0.2

              Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: false
                Layout.preferredWidth: uptimeText.width + uptimeText.anchors.leftMargin * 2

                color: root.buttonHoverColor

                Text {
                  id: uptimeText

                  anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 10
                  }

                  text: "Uptime"
                  color: root.textColor
                  font.pixelSize: parent.height * 0.5
                  font.weight: Font.Bold
                }
              }

              Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true

                color: root.textBarColor

                Text {
                  anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 10
                  }

                  text: root.uptimeText
                  color: root.textColor
                  font.pixelSize: parent.height * 0.5
                }
              }
            }

            RowLayout {
              spacing: 4

              Layout.alignment: Qt.AlignBottom
              Layout.fillWidth: true
              Layout.fillHeight: false
              Layout.preferredHeight: parent.height * 0.7

              Repeater {
                model: root.buttons

                delegate: Rectangle {
                  id: button
                  required property LogoutButton modelData;

                  Layout.fillWidth: true
                  Layout.fillHeight: false
                  Layout.preferredHeight: this.width

                  color: ma.containsMouse ? root.buttonHoverColor : root.buttonColor

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
                    width: parent.width * 0.5
                    height: parent.width * 0.5
                  }

                  Text {
                    anchors {
                      bottom: parent.bottom
                      bottomMargin: parent.height * 0.1
                      horizontalCenter: parent.horizontalCenter
                    }

                    text: button.modelData.text
                    font.pixelSize: parent.width * 0.12
                    font.weight: Font.Bold
                    color: root.textColor
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
