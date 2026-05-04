import QtQuick
import qs.Commons

Item {
  z: PathView.zindex || 1
  scale: PathView.scale || 1
  opacity: PathView.opacity || 1

  property bool isCurrent: PathView.isCurrentItem
  readonly property string wallpaperPath: model.wallpaperPath

  Rectangle {
    color: "transparent"
    width: parent.width
    height: parent.height
    clip: true

    Image {
      id: img
      width: parent.width
      height: parent.height
      source: model.cachedPath
      fillMode: Image.PreserveAspectCrop
      asynchronous: true
      smooth: true
      mipmap: true
    }

    Rectangle {
      anchors.fill: parent
      color: "transparent"
      border.color: Colors.mPrimary
      border.width: isCurrent ? 6 : 0
      z: 5
    }
  }

  readonly property real aspectRatio: img.implicitWidth > 0 ? img.implicitWidth / img.implicitHeight : 16 / 9
  readonly property real targetWidth: preferredHeight * aspectRatio

  width: targetWidth
  height: preferredHeight
}
