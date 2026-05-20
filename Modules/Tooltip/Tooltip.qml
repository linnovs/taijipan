import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Widgets
import qs.Commons

PopupWindow {
  id: root

  property var windowRoot
  property string title
  property string description
  property point position
  property bool isClosing: false

  readonly property int frameThickness: Theme.spacing * Settings.data.ui.frameThickness

  property int targetWidth: 0
  property int targetHeight: 0
  property real targetX: {
    if (position.x - targetWidth / 2 < 0)
      return Theme.marginXXS;

    if (position.x + targetWidth / 2 > parent.width - Theme.marginXXS)
      return parent.width - targetWidth - Theme.marginXXS;

    return position.x - targetWidth / 2;
  }
  property real targetY: position.y + Theme.marginXXS

  anchor.rect.x: targetX
  anchor.rect.y: targetY
  color: "transparent"
  visible: true
  implicitWidth: targetWidth
  implicitHeight: targetHeight

  signal tooltipClosed

  Timer {
    id: closeTimer
    interval: Theme.animationFast + Theme.timerRenderDelay
    onTriggered: root.tooltipClosed()
  }

  onIsClosingChanged: {
    if (!isClosing)
      return;

    closeTimer.restart();
  }

  Item {
    id: container
    anchors.fill: parent

    scale: isClosing ? 0.8 : 1
    opacity: isClosing ? 0 : 1

    Behavior on scale {
      NumberAnimation {
        duration: Theme.animationFast
        easing.type: Easing.InOutQuad
      }
    }

    Behavior on opacity {
      NumberAnimation {
        duration: Theme.animationFast
        easing.type: Easing.InOutQuad
      }
    }

    Rectangle {
      id: background
      width: parent.width
      height: parent.height
      radius: Theme.radiusSM
      color: Qt.alpha(Colors.mSurface, Settings.data.ui.tooltip.opacity)
    }

    DropShadow {
      anchors.fill: background
      source: background
      autoPaddingEnabled: true
    }

    Column {
      id: content
      anchors.centerIn: parent
      spacing: Theme.marginXXS

      Text {
        text: root.title
        visible: root.title.length > 0
        font.family: Settings.data.ui.font
        font.pixelSize: Theme.fontSizeSM
        font.weight: Font.DemiBold
        color: Colors.mOnSurface
      }

      Text {
        text: root.description
        font.family: Settings.data.ui.font
        font.pixelSize: Theme.fontSizeSM
        font.weight: Font.Normal
        color: Colors.mOnSurface
      }

      Component.onCompleted: {
        targetWidth = content.width + Theme.marginXXS * 2;
        targetHeight = content.height + Theme.marginXXS * 2;
      }
    }
  }

  BackgroundEffect.blurRegion: Region {
    width: isClosing ? 0 : background.width
    height: isClosing ? 0 : background.height

    Behavior on width {
      NumberAnimation {
        duration: Theme.animationFast
        easing.type: Easing.InOutQuad
      }
    }

    Behavior on height {
      NumberAnimation {
        duration: Theme.animationFast
        easing.type: Easing.InOutQuad
      }
    }

    radius: Theme.radiusSM
  }
}
