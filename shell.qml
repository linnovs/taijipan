import QtQuick
import Quickshell
import qs.Commons

ShellRoot {
  Component.onCompleted: {
    Logger.i("Shell", "         ☴     ☲     ☷");
    Logger.i("Shell", "         ☳     ☯      ☱");
    Logger.i("Shell", "         ☶     ☵     ☰");
    Logger.i("Shell", "Yin and Yang in One. Tai Ji Pan.");
  }

  property bool settingsLoaded: false

  Connections {
    target: Settings ? Settings : null
    function onSettingsLoaded() {
      settingsLoaded = true;
    }
  }

  Connections {
    target: Quickshell
    function onReloadCompleted() {
      Quickshell.inhibitReloadPopup();
    }
    function onReloadFailed() {
      if (Settings.isLoaded && !Settings.data.debug) {
        Quickshell.inhibitReloadPopup();
      }
    }
  }
}
