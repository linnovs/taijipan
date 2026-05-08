import QtQuick
import Quickshell
import Quickshell.Services.Pam
import qs.Commons

Scope {
  id: root

  property string password: ""
  property bool isUnlocking: false

  signal unlocked
  signal failed

  PamContext {
    id: pam

    configDirectory: "pam"
    config: "lockscreen.conf"

    onCompleted: result => {
      if (result === PamResult.Success) {
        root.unlocked();
        return;
      } else {
        root.password = "";
        root.failed();
      }

      root.isUnlocking = false;
    }
  }

  function tryUnlock() {
    root.isUnlocking = true;
    pam.start();
  }
}
