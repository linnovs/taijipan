import QtQuick
import QtQuick.Effects
import Quickshell

Item {
  id: root

  required property string name
  required property color color

  Image {
    id: iconImage
    anchors.centerIn: parent
    width: parent.width
    height: parent.height
    source: Quickshell.iconPath(root.name)
    sourceSize: Qt.size(width, height)
    mirror: true
    visible: false
  }

  MultiEffect {
    source: iconImage
    anchors.fill: iconImage
    colorization: 1
    colorizationColor: root.color
  }
}
