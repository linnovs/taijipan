pragma Singleton
import QtQuick
import Quickshell

Singleton {
  id: root

  readonly property int spacing: 4

  readonly property int animationBuffer: 200
  readonly property int animationSlowest: 700
  readonly property int animationSlow: 600
  readonly property int animationNormal: 400
  readonly property int animationFast: 200
  readonly property int animationFastest: 100
}
