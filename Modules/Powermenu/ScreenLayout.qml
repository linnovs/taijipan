pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Common

Variants {
  id: root

  required property string uptimeText
  default property list<LogoutButton> buttons

  signal close()

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
      color: Theme.base
      anchors.fill: parent
      opacity: 0.95

      MouseArea {
        anchors.fill: parent
        onClicked: root.close()
      }
    }

    Menu {
      anchors.centerIn: parent
      uptimeText: root.uptimeText
      buttons: root.buttons
      onClose: root.close()
    }
  }
}
