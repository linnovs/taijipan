import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import qs.Commons

RowLayout {
  id: osdContent

  property string icon: ""
  property real percentage: 0.0

  anchors.fill: parent
  anchors.leftMargin: Theme.marginXS
  anchors.rightMargin: Theme.marginXS
  spacing: Theme.spacing * 2

  TextMetrics {
    id: textMetrics
    text: "150%"
  }

  Image {
    source: Quickshell.iconPath(osdContent.icon)
    Layout.preferredWidth: Theme.iconSizeMD
    Layout.preferredHeight: Theme.iconSizeMD
    sourceSize.width: Layout.preferredWidth
    sourceSize.height: Layout.preferredHeight
    layer.enabled: true
    layer.effect: MultiEffect {
      colorization: 1
      colorizationColor: Colors.mOnSurface
    }
  }

  Rectangle {
    id: progress
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignVCenter
    Layout.preferredHeight: Theme.spacing * 2
    radius: Theme.radiusRound
    color: Colors.mSurfaceVariant

    Rectangle {
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.bottom: parent.bottom
      implicitWidth: parent.width * osdContent.percentage
      radius: Theme.radiusRound
      color: Colors.mOnSurface
    }
  }

  Text {
    Layout.preferredWidth: textMetrics.width
    text: Math.round(percentage * 100).toFixed(0) + "%"
    horizontalAlignment: Text.AlignRight
    color: Colors.mOnSurface
    font.weight: Font.DemiBold
  }
}
