pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons

Singleton {
  id: root

  property bool isConnected: false
  property string socketPath: Quickshell.env("NIRI_SOCKET")

  property ListModel workspaces: ListModel {}
  signal workspacesUpdated

  function handleWorkspacesUpdate(data) {
    const workspacesList = [];
    for (const ws of data) {
      workspacesList.push({
        id: ws.id,
        idx: ws.idx,
        name: ws.name || "",
        output: ws.output || "",
        isFocused: ws.is_focused === true,
        isActive: ws.is_active === true,
        isUrgent: ws.is_urgent === true,
        isOccupied: !!ws.active_window_id
      });
    }

    workspacesList.sort((a, b) => {
      if (a.output !== b.output)
        return a.output.localeCompare(b.output);
      return a.idx - b.idx;
    });

    workspaces.clear();
    for (let i = 0; i < workspacesList.length; i++) {
      workspaces.append(workspacesList[i]);
    }

    workspacesUpdated();
  }

  function sendMessage(sock, message) {
    sock.write(JSON.stringify(message) + "\n");
    sock.flush();
  }

  function startEventStream() {
    sendMessage(socketListener, "EventStream");
  }

  function updateWorkspaces() {
    sendMessage(socketCommander, "Workspaces");
  }

  function focusWorkspace(id) {
    sendMessage(socketCommander, {
      "Action": {
        "FocusWorkspace": {
          "reference": {
            "Id": id
          }
        }
      }
    });
  }

  Timer {
    id: workspacesUpdateTimer
    interval: Theme.timerDebounce
    onTriggered: updateWorkspaces()
  }

  Socket {
    id: socketListener
    path: root.socketPath
    parser: SplitParser {
      onRead: msg => {
        try {
          const event = JSON.parse(msg.trim());

          if (event.WorkspacesChanged) {
            handleWorkspacesUpdate(event.WorkspacesChanged.workspaces);
          } else if (event.WorkspaceActivated) {
            workspacesUpdateTimer.restart();
          } else if (Settings.data.debug) {
            Logger.d("NiriService", "Received event:", JSON.stringify(event));
          }
        } catch (err) {
          Logger.callStack(err.stack);
          Logger.e("NiriService", "Failed to parse event:", msg, "- Error:", err);
        }
      }
    }
  }

  Socket {
    id: socketCommander
    path: root.socketPath
    parser: SplitParser {
      onRead: msg => {
        try {
          const data = JSON.parse(msg.trim());

          if (data.Ok) {
            if (data.Ok.Workspaces) {
              handleWorkspacesUpdate(data.Ok.Workspaces);
            } else if (data.Ok === "Handled") {} else if (Settings.data.debug) {
              Logger.d("NiriService", "Received unknown command result:", JSON.stringify(data.Ok));
            }
          } else {
            Logger.w("NiriService", "Received command error:", JSON.stringify(data.Err));
          }
        } catch (err) {
          Logger.callStack(err.stack);
          Logger.e("NiriService", "Failed to parse command result:", msg, "- Error:", err);
        }
      }
    }
  }

  function init() {
    if (isConnected) {
      Logger.w("NiriService", "Already initialized");
      return;
    }

    Logger.d("NiriService", "Initializing NiriService with socket path:", root.socketPath);
    isConnected = true;
    socketListener.connected = true;
    socketCommander.connected = true;

    startEventStream();
    updateWorkspaces();
  }
}
