import QtQuick
import Quickshell
import qs.Commons
import qs.Modules.OSD
import qs.Modules.PanelScreen
import qs.Services

ShellRoot {
  id: root

  property bool settingsLoaded: false
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
    target: Settings ? Settings : null
    function onSettingsLoaded() {
      root.settingsLoaded = true;
    }
  }

  Connections {
    target: ShellState ? ShellState : null
    function onIsLoadedChanged() {
      if (!ShellState.isLoaded) return;
      root.stateLoaded = true;
    }
  }

  Loader {
    active: root.settingsLoaded && root.stateLoaded
    sourceComponent: Item {
      Component.onCompleted: {
        Logger.i("Shell", "------------------------------------")
        NiriService.init();

        Qt.callLater(() => {
          IPCServices.init(screenDetector);
        });

        Logger.d("Shell", "Main UI loaded.");
      }

      OSD {}
      PanelScreens {}

      CurrentScreenDetector {
        id: screenDetector
      }
    }
  }
}
