import QtQuick
import qs.Modules.TJPBar.Widgets

Item {
  id: root

  SectionComponent {
    anchors.right: parent.right
    items: ObjectModel {
      Component { SystemTray {} }
      Component { Status {} }
      Component { Notifications {} }
    }
  }
}
