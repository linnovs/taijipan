pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.Commons

RowLayout {
  id: root

  required property ObjectModel items

  implicitHeight: Theme.barInnerHeight

  Repeater {
    model: root.items.count
    Rectangle {
      id: sectionItem
      required property int index

      color: mouse.hovered ? Theme.surfaceVariant : Theme.surface
      radius: Theme.radiusL
      Layout.preferredWidth: itemLoader.width + Theme.spacing * 4
      Layout.preferredHeight: parent.height

      HoverHandler {
        id: mouse
      }

      Loader {
        id: itemLoader
        anchors.centerIn: parent
        sourceComponent: root.items.children[sectionItem.index]
      }
    }
  }
}
