pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Common

Menu {
  id: root

  required property QsMenuOpener menuOpener

  popupType: Popup.Window
  topPadding: Theme.spacing
  bottomPadding: Theme.spacing
  rightPadding: Theme.spacing * 2
  leftPadding: Theme.spacing * 2

  Repeater {
    model: root.menuOpener.children
    delegate: DelegateChooser {
      role: "isSeparator"
      DelegateChoice {
        roleValue: true
        MenuSeparator {
          contentItem: Rectangle {
            implicitHeight: 1
            color: Theme.surfaceSecondary
          }
        }
      }
      DelegateChoice {
        roleValue: false
        MenuItem {
          id: menuItem
          required property var modelData

          contentItem: RowLayout {
            spacing: Theme.spacing

            Image {
              source: menuItem.modelData.icon
              width: Theme.iconSize
              height: menuText.height
              sourceSize.width: width
              sourceSize.height: height
              fillMode: Image.PreserveAspectFit
            }

            Text {
              id: menuText

              Layout.fillWidth: true

              color: Theme.text
              text: menuItem.modelData.text + " "
            }
          }

          Component.onCompleted: {
            var maxWidth = Math.max(200, implicitWidth + Theme.spacing * 2, menuBackground.implicitWidth)
            menuBackground.implicitWidth = maxWidth
          }
        }
      }
    }
  }

  background: Rectangle {
    id: menuBackground
    color: Theme.surface
    radius: Theme.radiusS
  }
}
