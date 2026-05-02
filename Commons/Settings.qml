pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property bool isLoaded: false
  property bool createdDirectories: false
  property string settingsFile: Paths.configPath("settings.json")

  signal settingsLoaded
  signal settingsReloaded

  TextMetrics {
    id: defaultTextMetrics
  }

  JsonAdapter {
    id: settingsAdapter

    property bool rewriteNeeded: false
    property bool debug: false

    property JsonObject general: JsonObject {
      property string userIcon: Paths.homePath(".face")
      property real shadowOffsetX: 2
      property real shadowOffsetY: 3
      property real dimmerOpacity: 0
    }

    property JsonObject osd: JsonObject {
      property int autoDismissTimeout: 2000
      property real backgroundOpacity: 0.8
    }

    property JsonObject audio: JsonObject {
      property int volumeStep: 5
      property bool volumeFeedback: true
      property string volumeFeedbackSoundFile: ""
    }

    property JsonObject wallpaper: JsonObject {
      property bool enabled: false
      property color solidColor: Colors.mBackground
      property real overviewBlur: 0.4
      property real overviewTint: 0.6
      property string directory: ""
      property string sortBy: "name"
      property bool recursive: false
      property bool enableSlideshow: false
      property int slideshowInterval: 300
    }

    property JsonObject ui: JsonObject {
      property string font: defaultTextMetrics.font.family
    }

    property JsonObject powerMenu: JsonObject {
      property list<var> options: [
        {
          "action": "lock",
          "enable": true
        },
        {
          "action": "suspend",
          "enable": true
        },
        {
          "action": "hibernate",
          "enable": true
        },
        {
          "action": "reboot",
          "enable": true
        },
        {
          "action": "rebootToUEFI",
          "enable": true
        },
        {
          "action": "logout",
          "enable": true
        },
        {
          "action": "shutdown",
          "enable": true
        },
      ]
    }
  }

  readonly property alias data: settingsAdapter

  Timer {
    id: reloadDebounceTimer
    running: false
    interval: 200
    onTriggered: {
      if (createdDirectories && settingsFileView.path !== undefined) {
        Logger.i("Settings", "Reload settings after detected external change to file");
        settingsFileView.reload();
      }
    }
  }

  Timer {
    id: saveDebounceTimer
    running: false
    interval: 500
    onTriggered: settingsFileView.writeAdapter()
  }

  FileView {
    id: settingsFileView
    path: createdDirectories ? settingsFile : ""
    printErrors: false
    watchChanges: true

    onFileChanged: reloadDebounceTimer.restart()
    onAdapterUpdated: saveDebounceTimer.restart()
    onPathChanged: if (path !== undefined)
      reload()
    onLoaded: {
      if (!isLoaded) {
        Logger.i("Settings", "Loaded settings from file");
        isLoaded = true;
        root.settingsLoaded();
      } else {
        Logger.i("Settings", "Settings reloaded");
        root.settingsReloaded();
      }

      if (root.data.rewriteNeeded) {
        Logger.i("Settings", "Rewriting settings file to update format");
        root.save();
        root.data.rewriteNeeded = false;
      }
    }
  }

  function save() {
    saveDebounceTimer.restart();
  }

  Component.onCompleted: {
    Quickshell.execDetached(["mkdir", "-p", Paths.dataDir]);
    Quickshell.execDetached(["mkdir", "-p", Paths.stateDir]);
    Quickshell.execDetached(["mkdir", "-p", Paths.cacheDir]);
    Quickshell.execDetached(["mkdir", "-p", Paths.configDir]);
    Quickshell.execDetached(["mkdir", "-p", Paths.imagecacheDir]);

    createdDirectories = true;
    settingsFileView.adapter = settingsAdapter;
  }
}
