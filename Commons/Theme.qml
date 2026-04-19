pragma Singleton
import QtQuick
import Quickshell

Singleton {
  id: root

  readonly property string fontFamily: "Noto Sans CJK TC"
  readonly property string monoFontFamily: "JetBrains Mono NL"

  // spacing
  property int spacing: 4

  // shadow
  property int shadowBlurMax: 22
  property real shadowBlur: 1
  property real shadowOpacity: 0.85
  property real shadowHorizontalOffset: 3
  property real shadowVerticalOffset: 3

  // bar
  property int barHeight: spacing * 8
  property real barCapsuleRatio: 0.75
  property real barCapsuleHeight: barHeight * barCapsuleRatio
  property color barCapsuleColor: Qt.alpha(Colors.mSurface, 1)
  property color barCapsuleTextColor: Qt.alpha(Colors.mOnSurface, 1)
  property real barMarginHRatio: 0.1

  // notification
  property int notificationWidth: spacing * 110

  // powermenu
  property int powermenuButtonSize: spacing * 30
  property int powermenuUserIconSize: spacing * 23

  // osd
  property int osdWidth: spacing * 90
  property int osdHeight: spacing * 25

  // animation
  property int animationBuffer: 50
  property int animationFaster: 75
  property int animationFast: 150
  property int animationNormal: 300
  property int animationSlow: 450
  property int animationSlowest: 750

  // font
  property int fontSizeXXS: 7
  property int fontSizeXS: 8
  property int fontSizeS: 10
  property int fontSizeM: 12
  property int fontSizeL: 14
  property int fontSizeXL: 16
  property int fontSizeXXL: 18

  // icon
  property int iconSizeXS: spacing * 4
  property int iconSizeS: spacing * 6
  property int iconSizeM: spacing * 9
  property int iconSizeL: spacing * 12
  property int iconSizeXL: spacing * 16

  // margin
  property int marginXS: spacing / 2
  property int marginS: spacing
  property int marginM: spacing * 2
  property int marginL: spacing * 4
  property int marginXL: spacing * 8

  // radius
  property int radiusS: spacing
  property int radiusM: spacing * 2
  property int radiusL: spacing * 4
  property int radiusRound: spacing * 25

  // border
  property int borderS: 1
  property int borderM: 2
  property int borderL: 4
  property int borderXL: 8
}
