import QtQuick
import Quickshell
import qs.Commons
import qs.Modules.OSD
import qs.Modules.PanelScreen
import qs.Services

ShellRoot {
  id: root

  property bool stateLoaded: false

  Component.onCompleted: {
    Logger.i("Shell", "------------------------------------")
    Logger.i("Shell", "Starting TaiJiPan Shell...")
  }

  Connections {
    target: Quickshell
    function onReloadCompleted() {
      Quickshell.inhibitReloadPopup();
    }
  }

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
        Logger.i("Shell", "------------------------------------")
        Qt.callLater(() => {
          IPCServices.init(screenDetector);
        });

        Logger.d("Shell", "Main UI loaded.");
      }

      VolumeOSD {}
      PanelScreens {}

      CurrentScreenDetector {
        id: screenDetector
      }
    }
  }
}
