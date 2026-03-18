pragma Singleton

import QtQuick
import Quickshell
import qs.Commons

Singleton {
  id: root

  property var registeredPanels: ({})

  function registerPanel(panel) {
    registeredPanels[panel.objectName] = panel;
    Logger.d("PanelService", "Registered panel:", panel.objectName);
  }

  function getPanel(name, screen) {
    var panelKey = `${name}-${screen.name}`;

    if (registeredPanels[panelKey]) {
      return registeredPanels[panelKey];
    }

    Logger.w("PanelService", "Panel not found:", panelKey);
    return null;
  }
}
