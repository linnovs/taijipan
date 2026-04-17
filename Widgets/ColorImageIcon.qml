import QtQuick
import QtQuick.Effects
import Quickshell

Item {
  id: root

  required property string name
  required property color color
  property bool isIcon: true

  Image {
    id: iconImage

    anchors.centerIn: parent
    width: parent.width
    height: parent.height
    source: root.isIcon ? Quickshell.iconPath(root.name) : root.name
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
