pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import qs.Commons

Item {
  id: root

  required property var source
  property bool autoPaddingEnabled: false

  layer.enabled: true
  layer.effect: MultiEffect {
    source: root.source
    shadowEnabled: true
    blurMax: Theme.shadowBlurMax
    shadowBlur: Theme.shadowBlur
    shadowOpacity: Theme.shadowOpacity
    shadowColor: Colors.mShadow
    shadowHorizontalOffset: Theme.shadowHorizontalOffset
    shadowVerticalOffset: Theme.shadowVerticalOffset
    autoPaddingEnabled: autoPaddingEnabled
  }
}
