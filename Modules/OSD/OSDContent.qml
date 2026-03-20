import QtQuick
import QtQuick.Layouts
import qs.Widgets
import qs.Commons

RowLayout {
  id: root

  property Item background: null
  property int currentOSDType: -1
  property real percentage: 0.0
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
    color: Theme.text
  }

  Rectangle {
    visible: root.currentOSDType !== OSD.Type.LockKey
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignVCenter
    height: Theme.spacing * 2
    radius: height / 2
    color: Theme.overlaySecondary

    Rectangle {
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      width: parent.width * root.percentage
      radius: parent.radius
      color: Theme.text

      Behavior on width {
        NumberAnimation {
          duration: Theme.animationNormal
          easing.type: Easing.InOutQuad
        }
      }
    }
  }

  Text {
    visible: root.currentOSDType !== OSD.Type.LockKey
    text: `${Math.round(root.percentage * 100)}%`.padStart(4)
    color: Theme.text
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
