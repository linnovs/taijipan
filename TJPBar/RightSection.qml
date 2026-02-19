import QtQuick
import QtQuick.Layouts
import qs.TJPBar.Widgets

Item {
  id: root

  SectionComponent {
    anchors.right: parent.right
    items: ObjectModel {
      Component { SystemTray {} }
      Component { Status {} }
    }
  }
}
