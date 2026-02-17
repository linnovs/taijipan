import QtQuick
import QtQuick.Layouts
import qs.TJPBar.Widgets

Item {
  id: root

  SectionComponent {
    anchors.horizontalCenter: parent.horizontalCenter
    items: ObjectModel {
      Component { DateTime {} }
    }
  }
}
