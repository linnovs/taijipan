pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons

Singleton {
  id: root

  property var screenDetector: null

  function init(detector) {
    screenDetector = detector;
    Logger.i("IPCService", "IPC Service initialized");
  }

  IpcHandler {
    target: "powermenu"

    function open() {
      root.screenDetector.withCurrentScreen(screen => {
        var powermenuPanel = PanelService.getPanel("powermenu", screen);
        powermenuPanel?.toggle();
      });
    }
  }
}
