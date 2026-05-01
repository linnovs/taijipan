pragma Singleton
import QtQuick
import Quickshell
import qs.Commons

Singleton {
  id: root

  property var _panels: ({})
  property var _openedPanel: null
  property var _closingPanel: null

  readonly property bool isAnyPanelVisible: _openedPanel !== null
  property bool isKeybindRecording: false

  function hasPanel(name) {
    return name in _panels;
  }

  function getPanel(name, screen) {
    if (!screen) {
      Logger.d("PanelService", "getPanel called without screen for panel:", name);
      for (let key in _panels) {
        if (key.startsWith(name + "-")) {
          return _panels[key];
        }
      }
      return null;
    }

    let panelKey = `${name}-${screen.name}`;

    if (hasPanel(panelKey)) {
      return _panels[panelKey];
    }

    Logger.w("PanelService", "No panel found:", panelKey);
    return null;
  }

  function openingPanel(panel) {
    if (_openedPanel && _openedPanel !== panel) {
      _closingPanel = _openedPanel;
      _openedPanel.close();
    }

    _openedPanel = panel;
  }

  function closedPanel(panel) {
    if (_openedPanel && _openedPanel === panel) {
      _openedPanel = null;
    }

    if (_closingPanel && _closingPanel === panel) {
      _closingPanel = null;
    }
  }

  function closePanel() {
    if (_openedPanel && _openedPanel.close) {
      _openedPanel.close();
    }
  }

  function haveBackdrop() {
    return _openedPanel && _openedPanel.enableBackdrop && _openedPanel.isOpen;
  }

  function isPanelExclusiveKeyboardFocus() {
    return _openedPanel && _openedPanel.exclusiveKeyboardFocus;
  }

  function isPanelOpenOnScreen(screen) {
    return _openedPanel && _openedPanel.screen && _openedPanel.screen === screen;
  }

  function onEscapePressed() {
    return _openedPanel && _openedPanel.onEscapePressed ? _openedPanel.onEscapePressed() : false;
  }

  function registerPanel(panelItem) {
    if (panelItem.objectName) {
      _panels[panelItem.objectName] = panelItem;
      Logger.d("PanelService", "Registered panel with name:", panelItem.objectName);
    } else {
      Logger.w("PanelService", "Attempted to register a panel without an objectName");
    }
  }
}
