import QtQuick
import QtQuick.Layouts

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
