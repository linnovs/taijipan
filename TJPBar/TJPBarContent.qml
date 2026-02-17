import QtQuick
import qs.Common

Item {
  id: barContent

  required property var barWindow

  anchors.fill: parent
  anchors.leftMargin: Theme.spacing
  anchors.rightMargin: Theme.spacing
  anchors.topMargin: Theme.spacing
  anchors.bottomMargin: Theme.spacing

  LeftSection {
    height: parent.height
    anchors.left: parent.left
  }

  CenterSection {
    height: parent.height
    anchors.horizontalCenter: parent.horizontalCenter
  }

  RightSection {
    height: parent.height
    anchors.right: parent.right
  }
}
