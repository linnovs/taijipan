import QtQuick
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
  property bool exclusiveKeyboardFocus: false

  width: parent ? parent.width : 0
  height: parent ? parent.height : 0

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

  Loader {
    id: contentLoader
    active: isOpen && panelComponent !== null
    x: panelContainer.x
    y: panelContainer.y
    width: panelContainer.width
    height: panelContainer.height
    sourceComponent: root.panelComponent
    onLoaded: {
      Logger.d("BasePanel", "Panel content loaded for screen:", screen?.name);
    }
  }

  Item {
    id: panelContainer
  }

  Component.onCompleted: {
    PanelService.registerPanel(root);
  }

  function onEscapePressed() {
    close();
  }
}
