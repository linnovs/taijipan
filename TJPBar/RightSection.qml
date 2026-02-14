import QtQuick
import QtQuick.Layouts
import qs.TJPBar.Widgets

Item {
  id: root

  RowLayout {
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    layoutDirection: Qt.RightToLeft

    SystemTray {
      height: root.height
    }
  }
}
