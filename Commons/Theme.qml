pragma Singleton

import QtQuick
import Quickshell

Singleton {
  id: root

  readonly property string fontFamily: "Noto Sans CJK TC"
  readonly property string monoFontFamily: "JetBrains Mono NL"

  property color rosewater:         "#f5e0dc"
  property color flamingo:          "#f2cdcd"
  property color pink:              "#f5c2e7"
  property color mauve:             "#cba6f7"
  property color red:               "#f38ba8"
  property color maroon:            "#eba0ac"
  property color peach:             "#fab387"
  property color yellow:            "#f9e2af"
  property color green:             "#a6e3a1"
  property color teal:              "#94e2d5"
  property color sky:               "#89dceb"
  property color sapphire:          "#74c7ec"
  property color blue:              "#89b4fa"
  property color lavender:          "#b4befe"
  property color text:              "#cdd6f4"
  property color subtextSecondary:  "#bac2de"
  property color subtext:           "#a6adc8"
  property color overlayVariant:    "#9399b2"
  property color overlaySecondary:  "#7f849c"
  property color overlay:           "#6c7086"
  property color surfaceVariant:    "#585b70"
  property color surfaceSecondary:  "#45475a"
  property color surface:           "#313244"
  property color base:              "#1e1e2e"
  property color mantle:            "#181825"
  property color crust:             "#11111b"

  property int spacing: 4
  property int blurMax: 22

  property real   shadowBlur: 1.0
  property real   shadowOpacity: 0.85
  property color  shadowColor: "black"
  property real   shadowHorizontalOffset: 3
  property real   shadowVerticalOffset: 3

  property int barHeight: spacing * 8
  property int barInnerHeight: barHeight - spacing * 2
  property int barItemHeight: barInnerHeight - spacing * 2

  property int powermenuButtonSize: spacing * 30
  property int powermenuUserIconSize: spacing * 23

  property int osdWidth: spacing * 90
  property int osdHeight: spacing * 25

  property int animationFast: 150
  property int animationNormal: 300
  property int animationSlow: 450

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
