import QtQuick
import QtQuick.Layouts

Item {
  id: root

  width: childrenRect.width

  RowLayout {
    anchors.verticalCenter: parent.verticalCenter

    DateTime {}
  }
}
