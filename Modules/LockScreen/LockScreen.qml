import QtQuick
import Quickshell.Wayland
import qs.Services
import qs.Commons

Loader {
  id: root
  active: false

  property WlSessionLock lockSession

  Timer {
    id: unloadAfterUnlockTimer
    interval: 250
    onTriggered: active = false
  }

  function lock() {
    active = true;
  }

  function unlock() {
    if (lockSession) {
      lockSession.locked = false;
      unloadAfterUnlockTimer.restart();
      Logger.d("LockScreen", "Lock session unlocked, delaying unload to allow session to close properly");
      return;
    }

    Logger.d("LockScreen", "No lock session available, unlock failed");
  }

  Component.onCompleted: {
    PanelService.lockscreen = this;
  }

  sourceComponent: Item {
    LockContext {
      id: lockContext
    }

    WlSessionLock {
      locked: root.active

      WlSessionLockSurface {
        id: lockSurface
        color: Colors.mBackground

        Component {
          id: lockSurfaceDelegate
          LockSurface {
            context: lockContext
            screen: lockSurface.screen
            onFadeOutFinished: {
              root.unlock();
            }
          }
        }

        Loader {
          anchors.fill: parent
          active: lockSurface.screen !== null
          sourceComponent: lockSurfaceDelegate
        }
      }

      Component.onCompleted: {
        lockSession = this;
        Logger.d("LockScreen", "Lock session created:", lockSession);
      }
    }
  }
}
