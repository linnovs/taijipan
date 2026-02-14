pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray
import qs.Common

Item {
  id: root

  property var allItems: {
    return SystemTray.items.values
  }

  width: allItems.length * (Theme.iconSize + Theme.spacing) - Theme.spacing
  visible: allItems.length > 0

  RowLayout {
    anchors.fill: parent
    spacing: Theme.spacing

    Repeater {
      model: root.allItems
      delegate: Rectangle {
        id: trayItem

        required property var modelData
        width: Theme.iconSize
        height: root.height - Theme.spacing * 2
        radius: Theme.radiusS
        color: "transparent"

        ToolTip {
          id: trayTooltip
          popupType: Popup.Window
          x: trayItem.width / 2 - width / 2
          y: trayItem.height + Theme.spacing * 2

          contentItem: Column {
            Text {
              color: Theme.text
              font.bold: true
              text: trayItem.modelData.tooltipTitle ? trayItem.modelData.tooltipTitle : trayItem.modelData.title
            }

            Text {
              color: Theme.text
              text: trayItem.modelData.tooltipDescription
            }
          }

          background: Rectangle {
            color: Theme.surface
            radius: Theme.radiusS
          }
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
          onEntered: {
            parent.color = Theme.surface;
            trayTooltip.visible = true;
          }
          onExited: {
            parent.color = "transparent";
            trayTooltip.visible = false;
          }
          onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
              trayItem.modelData.activate();
            } else if (mouse.button === Qt.RightButton && trayItem.modelData.hasMenu) {
              trayTooltip.visible = false;
              contextMenu.popup();
            } else if (mouse.button === Qt.MiddleButton) {
              trayItem.modelData.secondaryActivate();
            }
          }

          TrayMenu {
            id: contextMenu

            QsMenuOpener {
              id: menuOpener
              menu: trayItem.modelData.menu
            }

            menuOpener: menuOpener
          }
        }

        Image {
          anchors.centerIn: parent
          source: trayItem.modelData.icon
          width: Theme.iconSize
          height: trayItem.height
          sourceSize.width: width
          sourceSize.height: height
        }
      }
    }
  }
}
