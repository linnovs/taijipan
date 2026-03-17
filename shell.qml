import QtQuick
import Quickshell
import qs.Commons
import qs.Modules.Powermenu
import qs.Modules.TJPBar
import qs.Modules.OSD
import qs.Services

ShellRoot {
  id: root

  property bool stateLoaded: false

  Connections {
    target: ShellState ? ShellState : null
    function onIsLoadedChanged() {
      if (!ShellState.isLoaded) return;
      Logger.d("Shell", "State initialized. Shell is ready.");
      root.stateLoaded = true;
    }
  }

  Loader {
    active: root.stateLoaded
    sourceComponent: Item {
      Component.onCompleted: {
        Qt.callLater(() => {
          IPCServices.init();
        });

        Logger.d("Shell", "Main UI loaded.");
      }

      Powermenu {}
      VolumeOSD {}
      TJPBar {}
    }
  }
}
