import QtQuick
import Quickshell
import Quickshell.Services.Pam

Scope {
  id: root
  signal unlocked()
  signal failed()

  property string password: ""
  property bool authenticating: false
  property bool failedAttempt: false

  onPasswordChanged: failedAttempt = false;

  PamContext {
    id: pam

    configDirectory: "pam"
    config: "tjpshell-lock.conf"

    onPamMessage: {
      if (this.responseRequired) {
        this.respond(root.password);
      }
    }

    onCompleted: result => {
      if (result == PamResult.Success) root.unlocked();
      else {
        root.password = "";
        root.failedAttempt = true;
      }

      root.authenticating = false;
    }
  }

  function tryUnlock() {
    if (password.length === 0 || authenticating) return;

    root.authenticating = true;
    pam.start();
  }
}
