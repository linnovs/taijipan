pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import Quickshell
import qs.Common

Item {
  id: root

  property var menu: null

  DelegateChooser {
    id: separatorChooser
    role: "isSeparator"
    DelegateChoice{
      roleValue: true
      delegate: menuSeparatorComponent
    }
    DelegateChoice{
      roleValue: false
      MenuItem {
        required property var modelData
        implicitTextPadding: Theme.spacing

        text: modelData.text
        icon.name: {
          if (modelData.icon) return
          if (modelData.hasChildren && !modelData.icon) {
            return "arrow-right"
          }
        }
        icon.source: modelData.icon
        icon.color: {
          if (modelData.icon.startsWith("image://qsimage")) return
          return Theme.surfaceVariant
        }

        onClicked: {
          if (modelData.hasChildren) {
            root.changeMenuHandle(modelData)
          } else {
            modelData.triggered()
          }
        }
      }
    }
  }

  Component {
    id: goBackComponent
    MenuItem {
      text: "Go Back"
      icon.name: "back"
      icon.color: Theme.surfaceVariant
      onClicked: root.goBack()
    }
  }

  Component {
    id: menuSeparatorComponent
    MenuSeparator {
      padding: 0
      topPadding: Theme.spacing
      bottomPadding: Theme.spacing
      leftPadding: Theme.spacing
      rightPadding: Theme.spacing
      contentItem: Rectangle {
        implicitHeight: 1
        color: Theme.surfaceVariant
      }
    }
  }

  Component {
    id: menuComponent

    Item {
      id: menuRoot
      required property QsMenuHandle menuHandle

      property Menu menuComp: innerMenu
      property ListModel subMenuModel: subMenuModel

      ListModel {
        id: subMenuModel
      }

      QsMenuOpener {
        id: menuOpener
        menu: menuRoot.menuHandle
      }

      QsMenuOpener {
        id: subMenuOpener
        menu: {
          const handle = subMenuModel.count > 0 ? subMenuModel.get(subMenuModel.count - 1) : null;
          return handle ? handle.menu : null;
        }
      }

      Menu {
        id: innerMenu

        popupType: Popup.Window
        topPadding: Theme.spacing
        bottomPadding: Theme.spacing
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside | Popup.CloseOnPressOutsideParent

        width: {
          var result = background.implicitWidth

          for (var i = 0; i < count; i++) {
            var item = itemAt(i)
            result = Math.max(item.implicitWidth + Theme.spacing * 2, result)
          }

          return result
        }

        enter: Transition {
          NumberAnimation {
            properties: "scale,opacity"
            from: 0
            to: 1
            duration: 150
          }
        }
        exit: Transition {
          NumberAnimation {
            properties: "scale,opacity"
            from: 1
            to: 0
            duration: 150
          }
        }

        Instantiator {
          model: {
            return subMenuModel.count > 0 ? subMenuOpener.children : menuOpener.children
          }
          delegate: separatorChooser

          onObjectAdded: (idx, obj) => innerMenu.insertItem(subMenuModel.count > 0 ? idx + 1: idx, obj)
          onObjectRemoved: (idx, obj) => innerMenu.removeItem(obj)
        }

        Instantiator {
          model: {
            return subMenuModel.count > 0 ? [null] : []
          }
          delegate: goBackComponent

          onObjectAdded: (idx, obj) => innerMenu.insertItem(0, obj)
          onObjectRemoved: (idx, obj) => innerMenu.removeItem(obj)
        }

        background: Rectangle {
          color: Theme.surface
          radius: Theme.radiusS
          implicitWidth: 200
        }
      }
    }
  }

  function updatePosition() {
    menu.menuComp.x = menu.parent.width / 2 - menu.menuComp.width / 2
    menu.menuComp.y = menu.parent.height + Theme.spacing * 3
  }

  function changeMenuHandle(menuHandle) {
    if (!menu) return

    menu.subMenuModel.append({menu: menuHandle})
    updatePosition()
  }

  function goBack() {
    if (!menu) return

    menu.subMenuModel.remove(menu.subMenuModel.count - 1)
    updatePosition()
  }

  function open(trayItem) {
    if (menu) {
      menu.destroy()
      menu = null;
    }

    menu = menuComponent.createObject(trayItem, {
      menuHandle: trayItem.modelData.menu,
    })

    if (!menu)
      return

    menu.menuComp.popup(trayItem.width / 2 - menu.menuComp.width / 2, trayItem.height + Theme.spacing * 3)
  }
}
