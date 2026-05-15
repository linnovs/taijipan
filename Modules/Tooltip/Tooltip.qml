import QtQuick
import Quickshell
import qs.Widgets
import qs.Commons

Item {
  id: root

  property var windowRoot
  property string title
  property string description
  property point position

  x: {
    if (position.x + implicitWidth > windowRoot.width)
      return windowRoot.width - implicitWidth;
    else if (position.x - implicitWidth / 2 < 0)
      return 0;
    else
      return position.x - implicitWidth / 2;
  }
  y: {
    if (position.y + implicitHeight > windowRoot.height)
      return windowRoot.height - implicitHeight;
    else
      return position.y;
  }

  Behavior on x {
    NumberAnimation {
      duration: Theme.animationFast
      easing.type: Easing.OutQuad
    }
  }

  Behavior on y {
    NumberAnimation {
      duration: Theme.animationFast
      easing.type: Easing.OutQuad
    }
  }

  scale: 0.8
  opacity: 0

  Behavior on scale {
    NumberAnimation {
      duration: Theme.animationFast
      easing.type: Easing.OutQuad
    }
  }

  Behavior on opacity {
    NumberAnimation {
      duration: Theme.animationFast
      easing.type: Easing.OutQuad
    }
  }

  Component.onCompleted: {
    scale = 1.0;
    opacity = 1.0;
  }

  property bool isClosing: false

  signal closed

  Timer {
    id: closeTimer
    interval: Theme.animationFast
    onTriggered: root.closed()
  }

  onIsClosingChanged: {
    if (!isClosing)
      return;

    scale = 0.8;
    opacity = 0.0;
    closeTimer.restart();
  }

  Rectangle {
    id: background
    anchors.fill: parent
    radius: Theme.radiusXL
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
  }

  implicitWidth: content.implicitWidth + Theme.marginXS * 2
  implicitHeight: content.implicitHeight + Theme.marginXS * 2
}
