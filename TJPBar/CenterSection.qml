import QtQuick
import QtQuick.Layouts

Item {
  id: root

  height: parent.height
  width: childrenRect.width

  RowLayout {
    id: rowComp

    anchors.verticalCenter: parent.verticalCenter

    DateTime {}
  }
}
