pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property bool isLoaded: false
  property string statePath: ""

  readonly property alias data: adapter

  FileView {
    id: stateFileView
    printErrors: false
    watchChanges: false

    onLoaded: {
      Logger.d("ShellState", "State loaded from " + root.statePath);
      root.isLoaded = true;
    }

    onLoadFailed: error => {
      if (error === 2) {
        root.isLoaded = true;
        Logger.d("ShellState", "State file not found. Will create a new one on save.");
      } else {
        Logger.e("ShellState", "Failed to load state file:", error);
        root.isLoaded = true;
      }
    }
  }

  JsonAdapter {
    id: adapter

    property JsonObject notifications: JsonObject {
      property int lastSeenTimestamp: 0
    }
  }

  function performSave() {
    if (!pendingSave || !statePath) {
      return;
    }

    pendingSave = false;

    try {
      Quickshell.execDetached(["mkdir", "-p", Paths.stateDir]);

      Qt.callLater(() => {
        try {
          stateFileView.writeAdapter();
          Logger.d("ShellState", "State saved to " + root.statePath);
        } catch(error) {
          Logger.e("ShellState", "Failed to write state file:", error);
        }
      })
    } catch(error) {
      Logger.e("ShellState", "Failed to save state: ", error);
    }
  }

  Timer {
    id: saveTimer
    interval: 500
    onTriggered: root.performSave()
  }

  property bool pendingSave: false

  function save() {
    pendingSave = true;
    saveTimer.restart();
  }

  Component.onCompleted: {
    Qt.callLater(() => {
      statePath = Paths.joinDir(Paths.stateDir, "state.json");
      stateFileView.adapter = adapter;
      stateFileView.path = statePath;
      Logger.d("ShellState", "Initialized ShellState with state file path:", statePath);
    })
  }
}
