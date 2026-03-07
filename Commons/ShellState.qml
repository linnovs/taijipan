pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property bool isLoaded: false
  property string statePath: ""

  Component.onCompleted: {
    Qt.callLater(() => {
      Logger.d("ShellState", "Initializing state...")
      statePath = Quickshell.statePath("state.json")
      stateFileView.path = statePath
    })
  }

  FileView {
    id: stateFileView
    printErrors: false
    watchChanges: false

    JsonAdapter {
    }

    onLoaded: {
      root.isLoaded = true
      Logger.d("ShellState", "State loaded from " + root.statePath)
    }

    onLoadFailed: error => {
      if (error === 2) {
        root.isLoaded = true
        Logger.d("ShellState", "State file not found. Will create a new one on save.")
      } else {
        Logger.e("ShellState", "Failed to load state file:", error)
        root.isLoaded = true
      }
    }
  }
}
