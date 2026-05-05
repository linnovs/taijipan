pragma Singleton
import QtQuick
import Quickshell

Singleton {
  id: root

  readonly property int spacing: 4

  readonly property int widthXS: spacing * 64
  readonly property int widthSM: spacing * 96
  readonly property int widthMD: spacing * 128
  readonly property int widthLG: spacing * 160
  readonly property int widthXL: spacing * 192

  readonly property int heightXS: spacing * 36
  readonly property int heightSM: spacing * 54
  readonly property int heightMD: spacing * 72
  readonly property int heightLG: spacing * 90
  readonly property int heightXL: spacing * 108

  readonly property int radiusXS: 2
  readonly property int radiusSM: 4
  readonly property int radiusMD: 6
  readonly property int radiusLG: 8
  readonly property int radiusXL: 12
  readonly property int radiusRound: 9999

  readonly property int marginXXS: spacing
  readonly property int marginXS: spacing * 2
  readonly property int marginSM: spacing * 4
  readonly property int marginMD: spacing * 6
  readonly property int marginLG: spacing * 8
  readonly property int marginXL: spacing * 12
  readonly property int marginXXL: spacing * 16

  readonly property int blurMax: spacing * 6
  readonly property real shadowBlur: 1.0
  readonly property real shadowOpacity: 1.0

  readonly property int animationBuffer: 200
  readonly property int animationSlowest: 700
  readonly property int animationSlow: 600
  readonly property int animationNormal: 400
  readonly property int animationFast: 200
  readonly property int animationFastest: 100

  readonly property int iconSizeXS: spacing * 4
  readonly property int iconSizeSM: spacing * 8
  readonly property int iconSizeMD: spacing * 16
  readonly property int iconSizeLG: spacing * 32
  readonly property int iconSizeXL: spacing * 64

  readonly property int fontSizeXS: spacing * 2
  readonly property int fontSizeSM: spacing * 3
  readonly property int fontSizeMD: spacing * 4
  readonly property int fontSizeLG: spacing * 5
  readonly property int fontSizeXL: spacing * 6

  readonly property int barMarginV: spacing * 2
  readonly property int barMarginH: spacing * 2
  readonly property int barHeight: spacing * 8

  readonly property int powerMenuIconSize: spacing * 32
  readonly property int powerMenuButtonIconSize: spacing * 16

  readonly property int notificationMinimumWidth: spacing * 104
  readonly property int notificationMinimumHeight: spacing * 26
  readonly property int notificationAppIconSize: spacing * 4
  readonly property int notificationImageSize: spacing * 24
}
