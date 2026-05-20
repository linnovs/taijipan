import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Modules.Popup
import qs.Services
import qs.Commons

PanelWindow {
  id: root

  WlrLayershell.layer: WlrLayer.Top
  WlrLayershell.exclusionMode: ExclusionMode.Ignore
  WlrLayershell.namespace: "taijipan-popup-" + (screen?.name || "unknown")
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

  color: "transparent"

  anchors.top: true
  anchors.right: true
  anchors.bottom: true
  anchors.left: true
  visible: false

  Item {
    id: anchorPoint
    x: 0
    y: 0
    width: 1
    height: 1
  }

  Item {
    id: fullscreenAnchor
    anchors.fill: parent
  }

  property var contextMenuCallback: null

  PopupContextMenu {
    id: contextMenu
    attachedScreen: root.screen
    anchorItem: anchorPoint
  }

  function showContextMenu(model, globalPos, callback) {
    contextMenuCallback = callback;
    visible = true;

    const pos = fullscreenAnchor.mapFromGlobal(globalPos);
    anchorPoint.x = pos.x + Theme.marginXXS;
    anchorPoint.y = pos.y + Theme.marginXXS;

    contextMenu.model = model;
    contextMenu.open();
  }

  function hideContextMenu() {
    contextMenu.close();
  }

  Connections {
    target: contextMenu
    function onPopupClosed() {
      visible = false;
    }
    function onTriggered(action, item) {
      if (contextMenuCallback) {
        const handled = root.contextMenuCallback(action, item);
        if (!handled)
          root.hideContextMenu();
      } else {
        root.hideContextMenu();
      }
    }
  }

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: hideContextMenu()
  }

  Item {
    anchors.fill: parent
    focus: true
    Keys.onEscapePressed: hideContextMenu()
  }

  Component.onCompleted: PanelService.registerPopupWindow(screen, root)

  Component.onDestruction: PanelService.unregisterPopupWindow(screen)
}
