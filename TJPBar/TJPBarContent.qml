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
    height: Theme.barRealHeight

    anchors {
      left: parent.left
    }
  }

  CenterSection {
    height: Theme.barRealHeight

    anchors {
      horizontalCenter: parent.horizontalCenter
    }
  }

  RightSection {
    height: Theme.barRealHeight

    anchors {
      right: parent.right
    }
  }
}
