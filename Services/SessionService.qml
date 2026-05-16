pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons

Singleton {
  id: root

  function _printActionOutput(action, command, text, isError) {
    if (text.length === 0) {
      Logger.d("SessionService", action, "with empty response - Command:", JSON.stringify(command));
      return;
    }

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
      onStreamFinished: _printActionOutput(actionProcess.action, actionProcess.command, text, false)
    }
    stderr: StdioCollector {
      onStreamFinished: {
        if (text === "")
          return;
        _printActionOutput(actionProcess.action, actionProcess.command, text, true);
      }
    }
  }

  property ListModel pendingActions: ListModel {}
  readonly property bool hasPendingAction: pendingActions.count

  Timer {
    id: actionDelayTimer
    interval: Theme.timerDebounceLong
    running: root.hasPendingAction
    onTriggered: {
      if (actionProcess.running || !root.hasPendingAction)
        return;

      const pendingAction = root.pendingActions.get(0);
      const command = JSON.parse(pendingAction.command);

      Logger.i("SessionService", "Execute pending command:", pendingAction.command, "for action", pendingAction.action);
      actionProcess.action = pendingAction.action;
      actionProcess.command = command;
      actionProcess.running = true;

      root.pendingActions.remove(0);
    }
  }

  function scheduleAction(action, command) {
    Logger.d("SessionService", "Schedule action", action, "with command", JSON.stringify(command));
    root.pendingActions.append({
      action,
      command: JSON.stringify(command)
    });
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
        PanelService.lockscreen?.lock();
      }
      Logger.i("SessionService", "Suspend system");
      root.scheduleAction(action, ["systemctl", "suspend"]);
      break;
    case "hibernate":
      Logger.i("SessionService", "Hibernate system");
      root.scheduleAction(action, ["systemctl", "hibernate"]);
      break;
    case "reboot":
      Logger.i("SessionService", "Reboot system");
      root.scheduleAction(action, ["systemctl", "reboot"]);
      break;
    case "rebootToUEFI":
      Logger.i("SessionService", "Reboot to UEFI");
      root.scheduleAction(action, ["bootctl", "reboot-to-firmware"]);
      break;
    case "logout":
      Logger.i("SessionService", "Log out");
      root.scheduleAction(action, ["loginctl", "terminate-user", "$USER"]);
      break;
    case "shutdown":
      Logger.i("SessionService", "Shut down system");
      root.scheduleAction(action, ["systemctl", "poweroff"]);
      break;
    default:
      Logger.w("SessionService", "Unknown action:", action);
      return;
    }
  }
}
