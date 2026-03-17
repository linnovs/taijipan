pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.Services
import qs.Commons

Loader {
  id: root
  active: false

  Component.onCompleted: {
    PanelService.powermenu = this
    Logger.d("Powermenu", "Power menu initialized.")
  }

  sourceComponent: Component {
    Variants {
      id: powermenuContainer

      model: Quickshell.screens
      property var activeScreen: null

      PanelWindow {
        id: powermenuWindow
        required property ShellScreen modelData
        screen: modelData

        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "taijipan-powermenu-" + (screen?.name || "unknown")
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        color: "transparent"

        contentItem {
          focus: true
          Keys.onPressed: event => {
            if (event.key === Qt.Key_Escape) root.active = false;
          }
        }

        anchors {
          top: true
          right: true
          bottom: true
          left: true
        }

        Rectangle {
          color: Theme.base
          opacity: 0.9
          anchors.fill: parent
        }

        MouseArea {
          id: ma
          anchors.fill: parent
          hoverEnabled: true
          onClicked: root.active = false
          onEntered: {
            if (powermenuContainer.activeScreen !== powermenuWindow.screen) {
              powermenuContainer.activeScreen = powermenuWindow.screen
            }
          }
        }

        Loader {
          active: powermenuContainer.activeScreen === powermenuWindow.screen
          anchors.centerIn: parent
          sourceComponent: ColumnLayout {
            anchors.centerIn: parent
            spacing: Theme.spacing * 4

            UserIcon {
              Layout.alignment: Qt.AlignHCenter
              Layout.bottomMargin: Theme.spacing * 4
            }

            MenuButtons {
              Layout.alignment: Qt.AlignHCenter
              onCommandExecuted: root.active = false
            }

            Uptime {
              Layout.alignment: Qt.AlignHCenter
            }
          }
        }
      }
    }
  }
}
