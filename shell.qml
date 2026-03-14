import QtQuick
import Quickshell
import qs.Commons
import qs.Modules.TJPBar
import qs.Modules.OSD

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
        Logger.d("Shell", "Main UI loaded.")
      }

      VolumeOSD {}
      TJPBar {}
    }
  }
}
