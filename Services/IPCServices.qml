pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons

Singleton {
  id: root

  function init() {
    Logger.d("IPCService", "IPC Service initialized")
  }

  IpcHandler {
    target: "powermenu"

    function open() {
      if (PanelService.powermenu && !PanelService.powermenu.active) {
        PanelService.powermenu.active = true
      }
    }
  }
}
