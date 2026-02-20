import QtQuick
import qs.Modules.TJPBar.Widgets

Item {
  id: root

  SectionComponent {
    anchors.horizontalCenter: parent.horizontalCenter
    items: ObjectModel {
      Component { DateTime {} }
    }
  }
}
