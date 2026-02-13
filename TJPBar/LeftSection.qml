import QtQuick
import QtQuick.Layouts
import qs.Common

Item {
  id: root

  RowLayout {
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter

    Text {
      text: "Left Section"
      color: Theme.blue
    }

    Rectangle {
      color: Theme.green
      width: Theme.iconSize
      height: Theme.iconSize
    }
  }
}
