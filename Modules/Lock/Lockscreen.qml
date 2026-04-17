pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland

Item {
  id: root

  signal unlocked

  WlSessionLock {
    id: lock

    locked: true

    WlSessionLockSurface {
      LockSurface {
        anchors.fill: parent
        ctx: lockCtx
      }
    }
  }

  LockContext {
    id: lockCtx

    onUnlocked: {
      lock.locked = false;
      root.unlocked();
    }
  }
}
