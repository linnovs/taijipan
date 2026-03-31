pragma Singleton

import QtQuick
import Quickshell

Singleton {
  id: root

  readonly property string fontFamily: "Noto Sans CJK TC"
  readonly property string monoFontFamily: "JetBrains Mono NL"

  property int spacing: 4
  property int blurMax: 22

  property real   shadowBlur: 1.0
  property real   shadowOpacity: 0.85
  property real   shadowHorizontalOffset: 3
  property real   shadowVerticalOffset: 3

  property int    barHeight: spacing * 8
  property real   barCapsuleRatio: 0.75
  property real   barCapsuleHeight: barHeight * barCapsuleRatio
  property color  barCapsuleColor: Qt.alpha(Colors.mSurface, 1.0)
  property color  barCapsuleTextColor: Qt.alpha(Colors.mOnSurface, 1.0)
  property real   barMarginHRatio: 0.1

  property int powermenuButtonSize: spacing * 30
  property int powermenuUserIconSize: spacing * 23

  property int osdWidth: spacing * 90
  property int osdHeight: spacing * 25

  property int animationBuffer: 50
  property int animationFaster: 75
  property int animationFast: 150
  property int animationNormal: 300
  property int animationSlow: 450
  property int animationSlowest: 750

  property int fontSizeS: 12
  property int fontSizeM: 14
  property int fontSizeL: 16

  property int iconSize: spacing * 6
  property int iconSizeL: spacing * 12

  property int marginS: spacing
  property int marginM: spacing * 2
  property int marginL: spacing * 4
  property int marginXL: spacing * 8

  property int radiusS: spacing
  property int radiusM: spacing * 2
  property int radiusL: spacing * 4
  property int radiusRound: spacing * 25
}
