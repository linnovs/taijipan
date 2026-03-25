import QtQuick
import Quickshell
import qs.Services
import qs.Commons

Item {
  id: root

  property ShellScreen  screen: null
  property Component    panelContent: null
  property bool         isOpen: false
  property bool         isVisible: false

  property bool   useButtonPosition: false
  property point  buttonPosition: Qt.point(0, 0)
  property int    buttonWidth: 0
  property int    buttonHeight: 0

  property bool panelAnchorHorizontalCenter: false
  property bool panelAnchorVerticalCenter: false
  property bool panelAnchorTop: false
  property bool panelAnchorRight: false
  property bool panelAnchorBottom: false
  property bool panelAnchorLeft: false

  property bool exclusiveKeyboard: true
  property bool closeOnEscape: true

  readonly property var panelRegion: panelContainer.geometryPlaceholder

  visible:  isVisible
  width:    parent ? parent.width : 0
  height:   parent ? parent.height : 0

  function onEscapePressed() {
    if (closeOnEscape) close();
  }

  function toggle(buttonItem) {
    if (isOpen) {
      close();
    } else {
      open(buttonItem)
    }
  }

  function open(buttonItem) {
    if (buttonItem && typeof buttonItem.mapToItem === "function") {
      try {
        var buttonLocal = buttonItem.mapToItem(null, 0, 0);

        root.buttonPosition = Qt.point(buttonLocal.x, buttonLocal.y);
        root.buttonWidth = buttonItem.width;
        root.buttonHeight = buttonItem.height;
        root.useButtonPosition = true;
      } catch(e) {
        Logger.w("Panel", "Failed to map button position for panel:", e);
        root.useButtonPosition = false;
      }
    }

    isOpen = true;
    PanelService.willOpenPanel(root);
  }

  function close() {
    isOpen = false;
    PanelService.closedPanel(root);
  }

  function setPosition() {
    if (!root.width || !root.height) {
      Logger.d("Panel", "Cannot set position for panel with zero width or height");
      Qt.callLater(setPosition);
      return;
    }

    var w;
    if (contentLoader.item && contentLoader.item.preferredWidth !== undefined) {
      w = contentLoader.item.preferredWidth;
    }

    var h;
    if (contentLoader.item && contentLoader.item.preferredHeight !== undefined) {
      h = contentLoader.item.preferredHeight;
    }

    panelBackground.targetWidth = w;
    panelBackground.targetHeight = h;

    var x, y;
    if (root.useButtonPosition) {
      x = root.buttonPosition.x + root.buttonWidth / 2 - w / 2;
      y = root.buttonPosition.y + root.buttonHeight / 2 - h / 2;
    } else {
      if (root.panelAnchorHorizontalCenter) {
        x = (root.width - panelBackground.targetWidth) / 2;
      } else if (root.panelAnchorRight) {
        x = root.width - panelBackground.targetWidth;
      } else if (root.panelAnchorLeft) {
        x = 0;
      }

      if (root.panelAnchorVerticalCenter) {
        y = (root.height - panelBackground.targetHeight) / 2;
      } else if (root.panelAnchorTop) {
        y = 0;
      } else if (root.panelAnchorBottom) {
        y = root.height - panelBackground.targetHeight;
      }
    }

    panelBackground.targetX = x;
    panelBackground.targetY = y;
  }

  Connections {
    target: contentLoader.item
    ignoreUnknownSignals: true
    function onPreferredHeightChanged() {
      if (root.isOpen && root.isVisible) root.setPosition();
    }
    function onPreferredWidthChanged() {
      if (root.isOpen && root.isVisible) root.setPosition();
    }
  }

  Item {
    id: panelContainer
    anchors.fill: parent

    property alias geometryPlaceholder: panelBackground

    Item {
      id: panelBackground
      property real targetX: root.x
      property real targetY: root.y
      property real targetWidth: 0
      property real targetHeight: 0
      x: targetX; y: targetY
      width: targetWidth; height: targetHeight

      MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        z: -1
        onClicked: mouse => {
          mouse.accepted = true;
        }
      }
    }

    Loader {
      id: contentLoader
      active: root.isOpen
      sourceComponent: root.panelContent
      x: panelBackground.x; y: panelBackground.y
      width: panelBackground.width; height: panelBackground.height
      onLoaded: {
        Qt.callLater(() => {
          setPosition();
          root.isVisible = true;
        })
      }
    }
  }

  Component.onCompleted: {
    PanelService.registerPanel(root);
  }
}
