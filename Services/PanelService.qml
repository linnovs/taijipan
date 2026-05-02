pragma Singleton
import QtQuick
import Quickshell
import qs.Commons

Singleton {
  id: root

  property var _panels: ({})
  property var openedPanel: null
  property var closingPanel: null

  readonly property bool isAnyPanelVisible: openedPanel !== null
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
    if (openedPanel && openedPanel !== panel) {
      closingPanel = openedPanel;
      openedPanel.close();
    }

    openedPanel = panel;
  }

  function closedPanel(panel) {
    if (openedPanel && openedPanel === panel) {
      openedPanel = null;
    }

    if (closingPanel && closingPanel === panel) {
      closingPanel = null;
    }
  }

  function closePanel() {
    if (openedPanel && openedPanel.close) {
      openedPanel.close();
    }
  }

  function onEscapePressed() {
    return openedPanel && openedPanel.onEscapePressed ? openedPanel.onEscapePressed() : false;
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
