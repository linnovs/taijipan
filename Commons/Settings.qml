pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property bool isLoaded: false
  property bool directoriesCreated: false

  readonly property alias data: adapter
  readonly property int version: 1
  readonly property string settingsFile: `${Paths.config}/settings.json`

  signal settingsLoaded
  signal settingsSaved

  Timer {
    id: saveTimer
    running: false
    interval: 500
    onTriggered: {
      root.save();
    }
  }

  FileView {
    id: settingsFileView
    path: root.directoriesCreated ? root.settingsFile : undefined
    printErrors: false
    watchChanges: true
    onAdapterUpdated: saveTimer.start()

    onFileChanged: {
      reload();
    }

    onPathChanged: {
      if (path !== undefined) {
        reload();
      }
    }

    onLoaded: {
      if (!root.isLoaded) {
        Logger.i("Settings", "Settings file loaded:", root.settingsFile);
        root.isLoaded = true;
        root.settingsLoaded();
      }
    }

    onLoadFailed: error => {
      if (error.toString().includes("No such file") || error === 2) {
        writeAdapter();
      }
    }
  }

  JsonAdapter {
    id: adapter

    property int version: 0

    property JsonObject general: JsonObject {
      property string avatarImage: Paths.strip(`${Paths.home}/.face`)
    }
  }

  Component.onCompleted: {
    // create config/cache/data directories if they don't exist
    // qmllint disable
    Quickshell.execDetached(["mkdir", "-p", Paths.strip(Paths.data)]);
    Quickshell.execDetached(["mkdir", "-p", Paths.strip(Paths.cache)]);
    Quickshell.execDetached(["mkdir", "-p", Paths.strip(Paths.config)]);
    // qmllint enable

    directoriesCreated = true;
    settingsFileView.adapter = adapter;
  }

  function save() {
    settingsFileView.writeAdapter();
    root.settingsSaved();
  }
}
