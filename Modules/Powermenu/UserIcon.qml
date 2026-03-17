pragma ComponentBehavior: Bound
import QtQuick
import Qt5Compat.GraphicalEffects
import qs.Commons

Item {
  id: root

  height: 90
  width: 90

  Image {
    id: userIcon
    anchors.fill: parent
    source: Paths.home + "/.face"
    fillMode: Image.PreserveAspectCrop

    layer.enabled: true
    layer.effect: OpacityMask {
      maskSource: ShaderEffectSource {
        sourceItem: Rectangle {
          width: userIcon.width
          height: userIcon.height
          radius: userIcon.width / 2
          color: "white"
        }
      }
    }
  }
}
