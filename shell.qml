import QtQuick
import Quickshell
import qs.Commons
import qs.Modules.Notification
import qs.Modules.OSD
import qs.Modules.PanelScreen
import qs.Services

ShellRoot {
  id: root

  property bool settingsLoaded: false
  property bool stateLoaded: false

  Component.onCompleted: {
    Logger.i("Shell", "------------------------------------");
    Logger.i("Shell", "Starting TaiJiPan Shell...");
  }

  Connections {
    function onReloadCompleted() {
      Quickshell.inhibitReloadPopup();
    }

    target: Quickshell
  }

  Connections {
    function onSettingsLoaded() {
      root.settingsLoaded = true;
    }

    target: Settings ? Settings : null
  }

  Connections {
    function onIsLoadedChanged() {
      if (!ShellState.isLoaded)
        return;

      root.stateLoaded = true;
    }

    target: ShellState ? ShellState : null
  }

  Loader {
    active: root.settingsLoaded && root.stateLoaded

    sourceComponent: Item {
      Component.onCompleted: {
        Logger.i("Shell", "------------------------------------");

        ColorService.init();

        Qt.callLater(() => {
          IPCServices.init(screenDetector);
        });

        Logger.d("Shell", "Main UI loaded.");
      }

      OSD {}
      PanelScreens {}
      Notification {}

      CurrentScreenDetector {
        id: screenDetector
      }
    }
  }
}
