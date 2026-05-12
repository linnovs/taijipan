import QtQuick
import Quickshell
import qs.Services
import qs.Commons

Item {
  id: root

  property ShellScreen screen: null
  property Component panelComponent: null
  property bool isOpen: false
  property bool isClosing: false
  property bool enableBackdrop: false
  property bool exclusiveKeyboardFocus: false

  width: parent ? parent.width : 0
  height: parent ? parent.height : 0

  enum Placement {
    Top,
    Center,
    Bottom
  }

  component PanelMarginObj: QtObject {
    property real top
    property real right
    property real bottom
    property real left
  }
  component PanelPositionObj: QtObject {
    property real x
    property real y
    property int placement: -1
    property bool horizontalCenter
    property bool verticalCenter
    property PanelMarginObj margins: PanelMarginObj {}
  }
  component PanelSize: QtObject {
    property real preferredWidth
    property real preferredHeight
    property real topMargin: 0
    property real rightMargin: 0
    property real bottomMargin: 0
    property real leftMargin: 0
  }

  property PanelPositionObj panelPosition: PanelPositionObj {}
  property PanelSize panelSize: PanelSize {}
  property bool scaleAnimation: false
  property real radius: Theme.radiusLG

  opacity: {
    if (isClosing) {
      return 0.0;
    } else if (isOpen) {
      return 1.0;
    }
    return 0.0;
  }

  Behavior on opacity {
    NumberAnimation {
      duration: Theme.animationNormal
      easing.type: Easing.InOutQuad
    }
  }

  function open() {
    PanelService.openingPanel(root);
    isOpen = true;
  }

  Timer {
    id: closingTimer
    interval: Theme.animationNormal
    repeat: false
    onTriggered: {
      isOpen = false;
      isClosing = false;
      PanelService.closedPanel(root);
    }
  }

  function close() {
    isClosing = true;
    closingTimer.restart();
  }

  function toggle() {
    if (isOpen) {
      close();
    } else {
      open();
    }
  }

  property alias panelContent: contentLoader.item
  property alias panelRegion: panelContainer
  property alias panelBackground: panelContainer.background

  Item {
    id: panelContainer

    property alias background: panelContainer

    readonly property int leftMargin: panelSize.preferredWidth ? panelSize.leftMargin : Theme.marginXL
    readonly property int rightMargin: panelSize.preferredWidth ? panelSize.rightMargin : Theme.marginXL
    readonly property int topMargin: panelSize.preferredWidth ? panelSize.topMargin : Theme.marginXL
    readonly property int bottomMargin: panelSize.preferredWidth ? panelSize.bottomMargin : Theme.marginXL
    readonly property int radius: root.radius

    readonly property int contentWidth: {
      if (panelSize.preferredWidth)
        return panelSize.preferredWidth + leftMargin + rightMargin;
      return (panelContent ? panelContent.implicitWidth : 0) + leftMargin + rightMargin;
    }
    readonly property int contentHeight: {
      if (panelSize.preferredHeight)
        return panelSize.preferredHeight + topMargin + bottomMargin;
      return (panelContent ? panelContent.implicitHeight : 0) + topMargin + bottomMargin;
    }

    scale: root.isClosing ? 0.8 : 1.0
    opacity: root.isClosing ? 0.0 : 1.0

    width: root.isClosing ? 0 : contentWidth
    height: root.isClosing ? 0 : contentHeight

    property real posX: {
      if (panelPosition.placement === BasePanel.Placement.Center || panelPosition.horizontalCenter) {
        return root.isClosing ? (parent.width - contentWidth / 2) / 2 : (parent.width - width) / 2;
      }
      return root.isClosing ? panelPosition.x + contentWidth / 2 : panelPosition.x;
    }
    property real posY: {
      if (panelPosition.placement === BasePanel.Placement.Center || panelPosition.verticalCenter) {
        return root.isClosing ? (parent.height - contentHeight / 2) / 2 : (parent.height - height) / 2;
      }
      if (panelPosition.placement === BasePanel.Placement.Top) {
        return root.isClosing ? contentHeight / 2 : 0;
      }
      if (panelPosition.placement === BasePanel.Placement.Bottom) {
        return root.isClosing ? parent.height - contentHeight / 2 : parent.height - height;
      }
      return root.isClosing ? panelPosition.y - contentHeight / 2 : panelPosition.y;
    }
    x: posX + panelPosition.margins.left - panelPosition.margins.right
    y: posY + panelPosition.margins.top - panelPosition.margins.bottom

    Behavior on x {
      enabled: !root.scaleAnimation
      NumberAnimation {
        duration: root.isClosing ? Theme.animationFast : Theme.animationNormal
        easing.type: Easing.OutBack
      }
    }

    Behavior on y {
      enabled: !root.scaleAnimation
      NumberAnimation {
        duration: root.isClosing ? Theme.animationFast : Theme.animationNormal
        easing.type: Easing.OutBack
      }
    }

    Behavior on scale {
      enabled: root.scaleAnimation
      NumberAnimation {
        duration: root.isClosing ? Theme.animationFast : Theme.animationNormal
        easing.type: Easing.OutBack
      }
    }

    Behavior on width {
      NumberAnimation {
        duration: root.isClosing ? Theme.animationFast : Theme.animationNormal
        easing.type: Easing.OutBack
      }
    }

    Behavior on height {
      NumberAnimation {
        duration: root.isClosing ? Theme.animationFast : Theme.animationNormal
        easing.type: Easing.OutBack
      }
    }

    MouseArea {
      anchors.fill: parent
      acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
      z: -1
      onClicked: mouse => mouse.accepted = true
    }
  }

  Loader {
    id: contentLoader
    active: isOpen && panelComponent !== null
    x: panelContainer.x + panelSize.leftMargin
    y: panelContainer.y + panelSize.topMargin
    width: isClosing ? 0 : panelContainer.width - panelSize.leftMargin - panelSize.rightMargin
    height: isClosing ? 0 : panelContainer.height - panelSize.topMargin - panelSize.bottomMargin
    scale: panelContainer.scale
    opacity: panelContainer.opacity
    sourceComponent: root.panelComponent
    onLoaded: {}
  }

  Component.onCompleted: {
    PanelService.registerPanel(root);
  }

  function onEscapePressed() {
    close();
  }
}
