pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Commons

Item {
  id: root

  property ShellScreen detectedScreen: null
  property var pendingCallback: null

  signal screenDetected(ShellScreen screen)

  onScreenDetected: screen => {
    detectedScreen = screen;
    screenDetectorDebounce.restart();
  }

  function withCurrentScreen(callback) {
    if (root.pendingCallback) {
      Logger.w("CurrentScreenDetector", "Another detection is pending, ignoring new call.");
      return;
    }

    pendingCallback = callback;
    screenDetectorLoader.active = true;
  }

  Timer {
    id: screenDetectorDebounce
    running: false; interval: 40
    onTriggered: {
      Logger.d("CurrentScreenDetector", "Screen debounced to:", root.detectedScreen?.name || "null");

      if (root.pendingCallback) {
        Logger.d("CurrentScreenDetector", "Invoking pending callback with screen:", root.detectedScreen.name);
        var callback = root.pendingCallback;
        root.pendingCallback = null;
        try {
          callback(root.detectedScreen);
        } catch(e) {
          Logger.e("CurnentScreenDetector", "Error invoking callback:", e);
        }
      }

      screenDetectorLoader.active = false;
    }
  }

  Loader {
    id: screenDetectorLoader
    active: false

    sourceComponent: PanelWindow {
      implicitWidth: 0; implicitHeight: 0
      color: "transparent"
      WlrLayershell.exclusionMode: ExclusionMode.Ignore
      WlrLayershell.namespace: "taijipan-screen-detector"
      mask: Region {}
      onScreenChanged: root.screenDetected(screen)
    }
  }
}
