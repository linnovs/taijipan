pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons

Singleton {
  id: root

  property var _registered: ({})
  readonly property int _registeredCount: Object.keys(root._registered).length
  readonly property bool shouldRun: _registeredCount > 0
  property bool initialized: false
  property bool numLockState: false
  property bool capsLockState: false
  property bool scrollLockState: false

  signal numLockChanged
  signal capsLockChanged
  signal scrollLockChanged

  function register(name) {
    _registered[name] = true;
    _registered = Object.assign({}, _registered);
    Logger.d("LockKeyService", "Registered:", name, "- Total:", _registeredCount);
  }

  function unregister(name) {
    delete _registered[name];
    _registered = Object.assign({}, _registered);
    Logger.d("LockKeyService", "Unregistered:", name, "- Total:", _registeredCount);
  }

  onShouldRunChanged: {
    if (!shouldRun)
      return;

    // prevent emitting changed signals on startup/reregister
    initialized = false;
    lockKeysProcess.running = true;
  }
  Component.onCompleted: {
    lockKeysProcess.running = true;
    Logger.i("LockKeyService", "Lock Key Service initialized");
  }

  Process {
    id: lockKeysProcess

    command: [Paths.joinDir(Paths.scripts, "lockKeys.sh")]

    stdout: StdioCollector {
      onStreamFinished: {
        try {
          const data = JSON.parse(text);
          if (data) {
            if (root.numLockState !== data.numlock) {
              root.numLockState = data.numlock;
              if (root.initialized)
                root.numLockChanged();

              Logger.i("LockKeyService", "Num Lock state changed:", data.numlock);
            }
            if (root.capsLockState !== data.capslock) {
              root.capsLockState = data.capslock;
              if (root.initialized)
                root.capsLockChanged();

              Logger.i("LockKeyService", "Caps Lock state changed:", data.capslock);
            }
            if (root.scrollLockState !== data.scrolllock) {
              root.scrollLockState = data.scrolllock;
              if (root.initialized)
                root.scrollLockChanged();

              Logger.i("LockKeyService", "Scroll Lock state changed:", data.scrolllock);
            }
          }
          if (!root.initialized)
            root.initialized = true;
        } catch (e) {
          Logger.e("LockKeysService", "Error parsing lock keys state:", e, "Raw output:", text);
        }
      }
    }
  }

  Timer {
    id: pollingTimer

    repeat: true
    interval: 200
    running: root.shouldRun
    onTriggered: {
      if (lockKeysProcess.running)
        return;

      lockKeysProcess.running = true;
    }
  }
}
