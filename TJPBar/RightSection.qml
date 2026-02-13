import QtQuick
import QtQuick.Layouts
import qs.Common

Item {
  id: root

  RowLayout {
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    layoutDirection: Qt.RightToLeft

    Text {
      text: "Right Section"
      color: Theme.red
    }

    Rectangle {
      color: Theme.pink
      width: Theme.iconSize
      height: Theme.iconSize
    }

    SystemTray {
      height: root.height
    }
  }
}
