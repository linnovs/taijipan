pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.Services
import qs.Commons

Singleton {
  id: root

  property ShellScreen detectedScreen: null
  property bool isDetecting: false

  property var pendingCallback: null

  Timer {
    id: callbackDebounceTimer
    interval: 40
    onTriggered: {
      Logger.d("IPCService", "Debounce timer triggered, executing pending callback with detected screen:", root.detectedScreen?.name);

      if (pendingCallback) {
        let callback = pendingCallback;
        pendingCallback = null; // Clear pending callback before execution to prevent reentrancy issues
        try {
          callback(root.detectedScreen);
        } catch (e) {
          Logger.e("IPCService", "Error running callback on detected screen:", e);
        }
      }

      isDetecting = false;
    }
  }

  signal screenChanged(ShellScreen screen)

  onScreenChanged: function (screen) {
    root.detectedScreen = screen;
    callbackDebounceTimer.restart();
  }

  Loader {
    id: detectScreenLoader
    active: isDetecting
    sourceComponent: PanelWindow {
      implicitWidth: 0
      implicitHeight: 0
      color: "transparent"
      WlrLayershell.exclusionMode: ExclusionMode.Ignore
      WlrLayershell.namespace: "taijipan-ipcservice-detectscreen"
      mask: Region {}
      onScreenChanged: root.screenChanged(screen)
    }
  }

  function init() {
    Logger.i("IPCService", "Initialize IPCService");
  }

  function runOnScreen(callback) {
    if (isDetecting) {
      Logger.w("IPCService", "Already detecting a screen, ignoring new request");
      return;
    }

    pendingCallback = callback;
    isDetecting = true;
  }

  IpcHandler {
    target: "powermenu"
    function toggle(): void {
      runOnScreen(screen => {
        let powermenu = PanelService.getPanel("powerMenu", screen);
        powermenu?.toggle();
      });
    }
  }

  IpcHandler {
    target: "volume"
    function increase(): void {
      AudioService.increaseVolume();
    }
    function decrease(): void {
      AudioService.decreaseVolume();
    }
    function toggleMute(): void {
      AudioService.setMuted(!AudioService.muted);
    }
  }

  IpcHandler {
    target: "wallpaper"
    function next(): void {
      if (Settings.data.wallpaper.enabled && Settings.data.wallpaper.enableSlideshow) {
        WallpaperService.setNextWallpaper();
      }
    }
    function set(path: string): void {
      if (Settings.data.wallpaper.enabled) {
        WallpaperService.changeWallpaper(path);
      }
    }
    function refresh(): void {
      WallpaperService.refreshWallpapers();
    }
  }
}
