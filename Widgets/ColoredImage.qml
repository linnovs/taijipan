import QtQuick
import QtQuick.Effects
import qs.Commons

Item {
  id: root

  required property string source
  required property size sourceSize
  property real colorization: 1.0
  property color colorizationColor: Colors.mOnSurface

  Image {
    id: sourceImage
    source: root.source
    sourceSize: root.sourceSize
    width: root.sourceSize.width
    height: root.sourceSize.height
    fillMode: Image.PreserveAspectCrop
    visible: false
  }

  MultiEffect {
    anchors.fill: sourceImage
    source: sourceImage
    colorization: root.colorization
    colorizationColor: root.colorizationColor
  }

  implicitWidth: sourceSize.width
  implicitHeight: sourceSize.height
}
