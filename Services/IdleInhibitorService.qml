pragma Singleton
import QtQuick
import Quickshell
import qs.Commons

Singleton {
  id: root

  property bool isIdleInhibited: false

  onIsIdleInhibitedChanged: {
    Logger.i("IdleInhibitorService", "Idle inhibition state changed:", isIdleInhibited);
  }

  function inhibitIdle() {
    if (!isIdleInhibited) {
      Logger.d("IdleInhibitorService", "Inhibiting idle");
      isIdleInhibited = true;
    }
  }

  function uninhibitIdle() {
    if (isIdleInhibited) {
      Logger.d("IdleInhibitorService", "Uninhibiting idle");
      isIdleInhibited = false;
    }
  }

  function init() {
    Logger.i("IdleInhibitorService", "Initialize service");
  }
}
