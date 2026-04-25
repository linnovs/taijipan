pragma Singleton
import QtQuick
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Io
import qs.Commons

Singleton {
  id: root

  property var _registered: ({})
  readonly property int _count: Object.keys(_registered).length
  readonly property bool shouldRun: _count > 0

  property bool capsLockOn: false
  property bool numLockOn: false
  property bool scrollLockOn: false

  signal capsLockChanged(bool on)
  signal numLockChanged(bool on)
  signal scrollLockChanged(bool on)

  function registerComponent(componentId) {
    root._registered[componentId] = true;
    root._registered = Object.assign({}, root._registered);
    Logger.d("LockKeyService", "Registered component:", componentId, "Total count:", root._count);
  }

  function unregisterComponent(componentId) {
    delete root._registered[componentId];
    root._registered = Object.assign({}, root._registered);
    Logger.d("LockKeyService", "Unregistered component:", componentId, "Total count:", root._count);
  }

  Instantiator {
    model: FolderListModel {
      folder: Qt.resolvedUrl("/sys/class/leds")
      showFiles: false
      showOnlyReadable: true
    }
    delegate: Component {
      FileView {
        path: filePath + "/brightness"
        printErrors: false
        watchChanges: false

        property string kind: {
          if (fileName.startsWith("input") && fileName.includes("::")) {
            return fileName.split("::")[1];
          }
          return "";
        }

        property bool isWantedFile: {
          if (fileName.startsWith("input") && fileName.includes("::")) {
            switch (fileName.split("::")[1]) {
            case "capslock":
            case "numlock":
            case "scrolllock":
              return true;
            }
          }
          return false;
        }

        function parseLockKeyStatus() {
          return text().trim() === "1";
        }

        function applyLockKeyState() {
          const state = parseLockKeyStatus();
          switch (kind) {
          case "capslock":
            if (initialized && root.capsLockOn !== state)
              root.capsLockChanged(state);
            root.capsLockOn = state;
            break;
          case "numlock":
            if (initialized && root.numLockOn !== state)
              root.numLockChanged(state);
            root.numLockOn = state;
            break;
          case "scrolllock":
            if (initialized && root.scrollLockOn !== state)
              root.scrollLockChanged(state);
            root.scrollLockOn = state;
            break;
          }
        }

        property bool initialized: false
        property variant connections: Connections {
          target: root
          function onShouldRunChanged() {
            // reset state to trigger change signals when service becomes active again
            initialized = false;
          }
        }

        onLoaded: {
          if (!isWantedFile)
            return;

          applyLockKeyState();
          if (!initialized)
            initialized = true;
        }

        property variant timer: Timer {
          interval: 200
          running: root.shouldRun && isWantedFile
          repeat: true
          onTriggered: reload()
        }
      }
    }
  }

  Component.onCompleted: {
    Logger.i("LockKeyService", "Service started (waiting for components to register)...");
  }
}
