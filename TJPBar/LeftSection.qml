import QtQuick
import QtQuick.Layouts
import qs.Common

Item {
  id: root

  height: parent.height

  RowLayout {
    id: rowComp

    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter

    Layout.fillWidth: true
    Layout.fillHeight: true

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
