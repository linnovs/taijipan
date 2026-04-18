pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons.Migrations

Singleton {
  id: root

  property bool isLoaded: false
  property bool directoriesCreated: false

  readonly property alias data: adapter
  readonly property int version: 1
  readonly property string settingsFile: Paths.joinDir(Paths.config, "settings.json")

  signal settingsLoaded
  signal settingsSaved
  signal settingsReloaded

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

        var rawJson = null;
        try {
          rawJson = JSON.parse(settingsFileView.text());
        } catch (e) {
          Logger.e("Settings", "Failed to parse settings file:", e);
        }

        if (root.runMigrations(rawJson)) {
          adapter.version = root.version;
        }

        root.isLoaded = true;
        root.settingsLoaded();
      } else {
        Logger.d("Settings", "Settings file changed, reloading...");
        root.settingsReloaded();
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
      property string avatarImage: Paths.joinDir(Paths.home, ".face")
    }

    property JsonObject bar: JsonObject {
      property JsonObject widgets
      property int widgetSpacing: Theme.spacing

      widgets: JsonObject {
        property list<var> left: []
        property list<var> center: [
          {
            "id": "DateTime"
          },
        ]
        property list<var> right: []
      }
    }

    property JsonObject notifications: JsonObject {
      property JsonObject timeouts

      timeouts: JsonObject {
        property int low: 3
        property int normal: 5
        property int critical: 0
      }
    }
  }

  Component.onCompleted: {
    // create config/cache/data directories if they don't exist
    Quickshell.execDetached(["mkdir", "-p", Paths.dataDir]);
    Quickshell.execDetached(["mkdir", "-p", Paths.cacheDir]);
    Quickshell.execDetached(["mkdir", "-p", Paths.configDir]);

    directoriesCreated = true;
    settingsFileView.adapter = adapter;
  }

  function runMigrations(rawJson) {
    if (!rawJson) {
      Logger.i("Settings", "Empty settings, skipping migrations.");
      return;
    }

    const currentVersion = adapter.version;
    const migrations = MigrationAgent.migrations;

    Logger.i("Settings", "Current settings version:", currentVersion);

    const versions = Object.keys(migrations).map(v => parseInt(v)).sort((a, b) => a - b);

    for (const version of versions) {
      Logger.d("Settings", "Checking migration for version:", version);
      if (currentVersion < version) {
        const migrationComp = migrations[version];
        const migration = migrationComp.createObject();

        if (migration && typeof migration.migrate === "function") {
          const success = migration.migrate(adapter, Logger, rawJson);
          if (!success) {
            Logger.e("Settings", "Migration to version", version, "failed. Aborting further migrations.");
            return false;
          }
        } else {
          Logger.e("Settings", "Invalid migration component for v" + version);
          return false;
        }

        if (migration) {
          migration.destroy();
        }
      }
    }

    return true;
  }

  function save() {
    settingsFileView.writeAdapter();
    root.settingsSaved();
  }
}
