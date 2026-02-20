import QtQuick
import QtQuick.Layouts
import qs.Services
import qs.Widgets
import qs.Common

Item {
  id: root

  implicitWidth: childrenRect.width
  implicitHeight: Theme.barItemHeight

  MouseArea {
    id: ma
    anchors.fill: parent
    onWheel: AudioService.adjustVolume(wheel.angleDelta.y > 0 ? 5 : -5)
  }

  RowLayout {
    spacing: 0

    ColorImageIcon {
      width: Theme.iconSize
      height: root.height
      name: AudioService.iconName
      color: Theme.text
    }

    Text {
      text: `${Math.round(AudioService.volume * 100)}%`
      color: Theme.text
    }
  }
}
