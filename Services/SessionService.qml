pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons

Singleton {
  id: root

  function _printActionOutput(action, command, text, isError) {
    Logger.d("SessionService", "-".repeat(52));
    Logger.d("SessionService", "Action:", action, "- Command:", JSON.stringify(command));
    Logger.d("SessionService", isError ? "- Error Output:" : "- Output:");
    const lines = text.split("\n");
    for (let i = 0; i < lines.length; i++) {
      const line = lines[i].trim();
      if (line.length > 0)
        Logger.d("SessionService", "-", line);
    }
    Logger.d("SessionService", "-".repeat(52));
  }

  Process {
    id: actionProcess
    property string action
    stdout: StdioCollector {
      onStreamFinished: _printActionOutput(this.action, this.command, this.text, false)
    }
    stderr: StdioCollector {
      onStreamFinished: _printActionOutput(this.action, this.command, this.text, true)
    }
  }

  property var pendingCommands: ([])

  Timer {
    id: actionDelayTimer
    interval: 250
    running: pendingCommands.length > 0
    onTriggered: {
      if (actionProcess.running || pendingCommands.length === 0)
        return;

      actionProcess.command = pendingCommands.shift();
      actionProcess.running = true;
    }
  }

  function executeAction(action) {
    switch (action) {
    case "lock":
      Logger.i("SessionService", "Lock screen");
      PanelService.lockscreen?.lock();
      break;
    case "suspend":
      if (Settings.data.general.lockOnSuspend) {
        Logger.i("SessionService", "Lock on suspend is enabled, lock screen before suspend");
        PanelService.lockScreen?.lock();
      }
      Logger.i("SessionService", "Suspend system");
      pendingCommands.push(["systemctl", "suspend"]);
      break;
    case "hibernate":
      Logger.i("SessionService", "Hibernate system");
      pendingCommands.push(["systemctl", "suspend"]);
      break;
    case "reboot":
      Logger.i("SessionService", "Reboot system");
      pendingCommands.push(["systemctl", "reboot"]);
      break;
    case "rebootToUEFI":
      Logger.i("SessionService", "Reboot to UEFI");
      pendingCommands.push(["bootctl", "reboot-to-firmware"]);
      break;
    case "logout":
      Logger.i("SessionService", "Log out");
      pendingCommands.push(["loginctl", "terminate-user", "$USER"]);
      break;
    case "shutdown":
      Logger.i("SessionService", "Shut down system");
      pendingCommands.push(["systemctl", "poweroff"]);
      break;
    }
  }
}
