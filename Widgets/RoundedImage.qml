import QtQuick
import QtQuick.Effects
import qs.Commons

Item {
  id: root

  required property string source
  required property size sourceSize

  Image {
    id: sourceImage
    width: root.width
    height: root.height
    source: root.source
    sourceSize: root.sourceSize
    fillMode: Image.PreserveAspectCrop
    visible: false
  }

  Item {
    id: maskSource
    anchors.fill: sourceImage
    visible: false
    layer.enabled: true
    Rectangle {
      anchors.fill: parent
      radius: Theme.radiusRound
    }
  }

  MultiEffect {
    anchors.fill: parent
    source: sourceImage
    maskEnabled: true
    maskSource: maskSource
  }
}
