import QtQuick
import QtQuick.Effects
import qs.Commons

Item {
  id: root

  required property var source

  property bool autoPaddingEnabled: false
  property real shadowHorizontalOffset: Settings.data.general.shadowOffsetX
  property real shadowVerticalOffest: Settings.data.general.shadowOffsetY
  property real shadowBlur: Theme.shadowBlur
  property real shadowOpacity: Theme.shadowOpacity

  layer.enabled: true
  layer.effect: MultiEffect {
    source: root.source
    shadowEnabled: true
    blurMax: Theme.blurMax
    shadowBlur: root.shadowBlur
    shadowOpacity: root.shadowOpacity
    shadowColor: Colors.mShadow
    shadowHorizontalOffset: root.shadowHorizontalOffset
    shadowVerticalOffset: root.shadowVerticalOffest
    autoPaddingEnabled: root.autoPaddingEnabled
  }
}
