import QtQuick
import QtQuick.Layouts
import qs.TJPBar.Widgets

Item {
  id: root

  RowLayout {
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter

    DateTime {}
  }
}
