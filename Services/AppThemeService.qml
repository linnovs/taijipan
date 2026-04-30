pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons

Singleton {
  id: root

  property bool hasMategun: false
  property string currentWallpaper: ""

  Process {
    id: mategunProcess
    command: ["matugen", "image", currentWallpaper]
    stdout: StdioCollector {}
    stderr: StdioCollector {}
  }

  Timer {
    id: debounceGenerateTimer
    interval: 500
    onTriggered: {
      if (!hasMategun) {
        Logger.w("AppThemeService", "Mategun not found, skipping wallpaper palette generation");
        return;
      }

      mategunProcess.running = true;
    }
  }

  Connections {
    target: WallpaperService
    function onWallpaperChanged(screenName, wallpaperPath) {
      currentWallpaper = wallpaperPath;
      debounceGenerateTimer.restart();
    }
  }

  Process {
    id: checkMategunProcess
    command: ["sh", "-c", "command -v matugen"]
  }

  Connections {
    target: checkMategunProcess
    function onExited(exitCode) {
      root.hasMategun = exitCode === 0;
      if (root.hasMategun) {
        Logger.i("AppThemeService", "Mategun found, will generate wallpaper palette on wallpaper change");
      } else {
        Logger.w("AppThemeService", "Mategun not found in PATH, wallpaper palette generation disabled");
      }
    }
  }

  function init() {
    Logger.i("AppThemeService", "Initialize service");
    checkMategunProcess.running = true;
  }
}
