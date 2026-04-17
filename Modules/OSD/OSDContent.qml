import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

RowLayout {
  id: root

  property Item background: null
  property int currentOSDType: -1
  property real percentage: 0
  property string displayText: ""
  property string iconName: ""

  anchors.fill: background
  anchors.leftMargin: Theme.marginM
  anchors.rightMargin: Theme.marginM
  spacing: Theme.marginS

  TextMetrics {
    id: percentageMetrics

    font.family: Theme.fontFamily
    font.pointSize: Theme.fontSizeS
    text: "150%"
  }

  ColorImageIcon {
    width: Theme.iconSizeL
    height: Theme.iconSizeL
    name: root.iconName
    color: Colors.mOnBackground
  }

  Text {
    visible: root.currentOSDType === OSD.Type.NumLock || root.currentOSDType === OSD.Type.CapsLock || root.currentOSDType === OSD.Type.ScrollLock
    text: root.displayText
    color: Colors.mOnBackground
    font.family: Theme.fontFamily
    font.pointSize: Theme.fontSizeM
    font.weight: Font.Medium
    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    Layout.fillWidth: true
  }

  // percentage bar
  Rectangle {
    visible: root.currentOSDType === OSD.Type.Volume
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignVCenter
    height: Theme.spacing * 2
    radius: height / 2
    color: Colors.mSurfaceContainer

    Rectangle {
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      width: parent.width * Math.min(1, root.percentage)
      radius: parent.radius
      color: Colors.mOnSurface

      Behavior on width {
        NumberAnimation {
          duration: Theme.animationNormal
          easing.type: Easing.InOutQuad
        }
      }
    }
  }

  // percentage text
  Text {
    visible: root.currentOSDType === OSD.Type.Volume
    text: root.displayText
    color: Colors.mOnBackground
    font.family: Theme.fontFamily
    font.pointSize: Theme.fontSizeS
    font.weight: Font.Medium
    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
    horizontalAlignment: Text.AlignRight
    verticalAlignment: Text.AlignVCenter
    Layout.fillWidth: false
    Layout.preferredWidth: Math.ceil(percentageMetrics.width)
  }
}
