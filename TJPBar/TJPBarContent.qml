import QtQuick
import qs.Common

Item {
  id: barContent

  required property var barWindow

  anchors.fill: parent
  anchors.leftMargin: Theme.spacing
  anchors.rightMargin: Theme.spacing

  LeftSection {
    anchors {
      left: parent.left
      verticalCenter: parent.verticalCenter
    }
  }

  CenterSection {
    anchors {
      verticalCenter: parent.verticalCenter
      horizontalCenter: parent.horizontalCenter
    }
  }

  RightSection {
    anchors {
      right: parent.right
      verticalCenter: parent.verticalCenter
    }
  }
}
