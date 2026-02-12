import QtQuick
import QtQuick.Layouts
import qs.Common

Item {
  id: root

  height: parent.height

  RowLayout {
    id: rowComp

    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    layoutDirection: Qt.RightToLeft

    Layout.fillWidth: true
    Layout.fillHeight: true

    Text {
      text: "Right Section"
      color: Theme.red
    }

    Rectangle {
      color: Theme.pink
      width: Theme.iconSize
      height: Theme.iconSize
    }
  }
}
