import QtQuick
import qs.Widgets
import qs.Commons

Item {
  id: osdItem

  property string icon: ""
  property real percentage: 0.0

  anchors.centerIn: parent

  implicitWidth: Theme.widthXS + Theme.marginSM * 2
  implicitHeight: osdContent.implicitHeight + Theme.marginXS * 2

  opacity: 0.0
  scale: 0.85

  Behavior on opacity {
    NumberAnimation {
      duration: Theme.animationNormal
      easing.type: Easing.InOutQuad
    }
  }

  Behavior on scale {
    NumberAnimation {
      duration: Theme.animationNormal
      easing.type: Easing.InOutQuad
    }
  }

  Rectangle {
    id: background
    anchors.fill: parent
    radius: Theme.radiusMD
    color: Colors.mSurface
  }

  DropShadow {
    anchors.fill: background
    source: background
    autoPaddingEnabled: true
  }

  OSDContent {
    id: osdContent
    icon: osdItem.icon
    percentage: osdItem.percentage
  }

  function show() {
    osdItem.opacity = Settings.data.osd.backgroundOpacity;
    osdItem.scale = 1.0;
  }

  function hide() {
    osdItem.scale = 0.85;
    osdItem.opacity = 0.0;
  }
}
