import QtQuick
import qs.Common

Item {
  id: root

  SectionComponent {
    anchors.left: parent.left
    items: ObjectModel {
      Component {
        Item {
          width: childrenRect.width
          height: Theme.barItemHeight

          Row {
            spacing: Theme.spacing
            Text {
              text: "Left section"
              color: Theme.blue
            }

            Rectangle {
              color: Theme.green
              width: Theme.iconSize
              height: Theme.barItemHeight
            }
          }
        }
      }
    }
  }
}
