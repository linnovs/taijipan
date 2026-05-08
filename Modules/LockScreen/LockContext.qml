import QtQuick
import Quickshell
import Quickshell.Services.Pam
import qs.Commons

Scope {
  id: root

  property string password: ""
  property bool isUnlocking: false

  signal unlocked

  PamContext {
    id: pam

    configDirectory: "pam"
    config: "lockscreen.conf"

    onPamMessage: if (pam.responseRequired)
      pam.respond(password)

    onCompleted: result => {
      if (result === PamResult.Success) {
        root.unlocked();
        return;
      } else {
        root.password = "";
      }

      root.isUnlocking = false;
      Logger.e("LockScreen", "PAM authentication failed with result:", pam.error());
    }
  }

  function tryUnlock() {
    root.isUnlocking = true;
    pam.start();
  }
}
