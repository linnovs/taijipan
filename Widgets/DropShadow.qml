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
    blurMax: Theme.blurMax
    shadowBlur: Theme.shadowBlur
    shadowOpacity: Theme.shadowOpacity
    shadowColor: Theme.shadowColor
    shadowHorizontalOffset: Theme.shadowHorizontalOffset
    shadowVerticalOffset: Theme.shadowVerticalOffset
    autoPaddingEnabled: autoPaddingEnabled
  }
}
