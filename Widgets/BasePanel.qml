import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Services
import qs.Commons

Item {
  id: root

  property ShellScreen screen: null
  property Component panelComponent: null
  property bool isOpen: false
  property bool placeInCenter: false
  property bool isClosing: false
  property bool enableBackdrop: false
  property bool exclusiveKeyboardFocus: false

  width: parent ? parent.width : 0
  height: parent ? parent.height : 0

  component PanelPositionObj: QtObject {
    property int x
    property int y
    property bool placeInCenter
    property bool horizontalCenter
    property bool verticalCenter
  }
  component PanelSize: QtObject {
    property int preferredWidth
    property int preferredHeight
  }

  property PanelPositionObj panelPosition: PanelPositionObj {}
  property PanelSize panelSize: PanelSize {}

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

  Item {
    id: panelContainer

    readonly property int leftMargin: Theme.marginXL
    readonly property int rightMargin: Theme.marginXL
    readonly property int topMargin: Theme.marginXL
    readonly property int bottomMargin: Theme.marginXL

    readonly property int contentWidth: {
      return panelSize.preferredWidth || (panelContent ? panelContent.implicitWidth : 0) + leftMargin + rightMargin;
    }
    readonly property int contentHeight: {
      return panelSize.preferredHeight || (panelContent ? panelContent.implicitHeight : 0) + topMargin + bottomMargin;
    }

    scale: root.isClosing ? 0.8 : 1.0
    opacity: root.isClosing ? 0.0 : 1.0

    width: contentWidth
    height: contentHeight

    x: {
      if (panelPosition.placeInCenter || panelPosition.horizontalCenter) {
        return (parent.width - width) / 2;
      }
      return panelPosition.x;
    }
    y: {
      if (panelPosition.placeInCenter || panelPosition.verticalCenter) {
        return (parent.height - height) / 2;
      }
      return panelPosition.y;
    }

    Behavior on scale {
      NumberAnimation {
        duration: root.isClosing ? Theme.animationFast : Theme.animationNormal
        easing.type: Easing.OutBack
      }
    }

    Behavior on opacity {
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
      onClicked: mouse.accepted = true
    }
  }

  Loader {
    id: contentLoader
    active: isOpen && panelComponent !== null
    x: panelContainer.x
    y: panelContainer.y
    width: panelContainer.width
    height: panelContainer.height
    scale: panelContainer.scale
    opacity: panelContainer.opacity
    sourceComponent: root.panelComponent
    onLoaded: {
      Logger.d("BasePanel", "Panel content loaded for screen:", screen?.name);
    }
  }

  Component.onCompleted: {
    PanelService.registerPanel(root);
  }

  function onEscapePressed() {
    close();
  }
}
