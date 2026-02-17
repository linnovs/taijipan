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

  property real spacing: 4
  property real barHeight: 40
  property real barRealHeight: 32
  property real iconSize: 24
  property real radiusS: 4
  property real radiusM: 8
  property real radiusL: 12
  property real radiusRound: 100
}
