import QtQuick
import qs.Common

Item {
  id: barContent

  required property var barWindow

  anchors.fill: parent
  anchors.leftMargin: Theme.spacing
  anchors.rightMargin: Theme.spacing

  LeftSection {
    height: barContent.barWindow.height

    anchors {
      left: parent.left
    }
  }

  CenterSection {
    height: barContent.barWindow.height

    anchors {
      horizontalCenter: parent.horizontalCenter
    }
  }

  RightSection {
    height: barContent.barWindow.height

    anchors {
      right: parent.right
    }
  }
}
