pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.SystemTray
import qs.Common

Item {
  id: root

  property var allItems: {
    return SystemTray.items.values
  }

  width: allItems.length * (Theme.iconSize + Theme.spacing) - Theme.spacing + Theme.spacing * 4
  visible: allItems.length > 0

  TrayMenu {
    id: trayMenu
  }

  Rectangle {
    anchors.fill: parent
    color: Theme.mantle
    radius: Theme.radiusRound
  }

  RowLayout {
    id: trayRow
    anchors.fill: parent
    spacing: Theme.spacing
    anchors.leftMargin: Theme.spacing * 2
    anchors.rightMargin: Theme.spacing * 2

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
          y: trayItem.height + Theme.spacing * 3

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
              trayMenu.open(trayItem)
            } else if (mouse.button === Qt.MiddleButton) {
              trayItem.modelData.secondaryActivate();
            }
          }
        }

        Image {
          anchors.centerIn: parent
          source: {
            const icon = trayItem.modelData.icon

            if (icon.startsWith("image://qsimage")) return icon

            const regex = /-symbolic$/i;
            return icon.replace(regex, "")
          }
          width: Theme.iconSize
          height: trayItem.height
          sourceSize.width: width
          sourceSize.height: height
        }
      }
    }
  }
}
