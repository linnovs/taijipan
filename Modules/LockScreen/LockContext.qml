import QtQuick
import Quickshell
import Quickshell.Services.Pam
import qs.Commons

Scope {
  id: root

  property string password: ""
  property bool isUnlocking: false
  property string message: ""
  property bool isErrorMessage: false

  signal unlocked
  signal failed

  PamContext {
    id: pam

    configDirectory: "pam"
    config: "lockscreen.conf"

    onPamMessage: {
      Logger.i("LockScreen", "PAM message:", pam.message, "- isError:", pam.messageIsError, "- responseRequired:", pam.responseRequired);

      if (pam.responseRequired) {
        pam.respond(password);
      } else if (pam.messageIsError) {
        root.message = pam.message;
        root.isErrorMessage = true;
        root.failed();
      } else {
        root.message = pam.message;
        root.isErrorMessage = false;
      }
    }

    onError: error => {
      Logger.e("LockScreen", "PAM authentication error:", PamError.toString(error));
      root.message = pam.message || "Authentication error";
      root.isErrorMessage = true;
      root.isUnlocking = false;
      root.failed();
    }

    onCompleted: result => {
      if (result === PamResult.Success) {
        root.unlocked();
      } else {
        root.message = "Authentication failed";
        root.isErrorMessage = true;
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
