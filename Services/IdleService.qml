pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Commons

Singleton {
  id: root

  IdleMonitor {
    id: suspendIdleMonitor
    enabled: Settings.data.idle.enabled || false
    timeout: Settings.data.idle.suspendAfter * 60 * 1000
  }

  Connections {
    target: suspendIdleMonitor
    function onIsIdleChanged() {
      if (suspendIdleMonitor.isIdle) {
        Logger.i("IdleService", "System idle detected, executing suspend action");
        SessionService.executeAction("suspend");
      }
    }
  }

  function init() {
    Logger.i("IdleService", "Initialize IdleService");
    Logger.i("IdleService", "Idle suspend", suspendIdleMonitor.enabled ? "enabled" : "disabled", "- Timeout (mins):", suspendIdleMonitor.timeout / (60 * 1000));
  }
}
