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
    property bool debugNiri: false

    property JsonObject general: JsonObject {
      property string userIcon: Paths.homePath(".face")
      property real shadowOffsetX: 2
      property real shadowOffsetY: 3
      property real dimmerOpacity: 0
      property JsonObject keybinds: JsonObject {
        property list<string> left: ["H"]
        property list<string> right: ["L"]
        property list<string> enter: ["Return", "Enter"]
        property list<string> esc: ["Esc"]
      }
      property bool lockOnSuspend: true
    }

    property JsonObject osd: JsonObject {
      property int autoDismissTimeout: 2
      property real backgroundOpacity: 0.8
    }

    property JsonObject audio: JsonObject {
      property int volumeStep: 5
      property bool volumeFeedback: true
      property string volumeFeedbackSoundFile: ""
    }

    property JsonObject wallpaper: JsonObject {
      property bool enabled: false
      property real overviewBlur: 0.4
      property real overviewTint: 0.6
      property string directory: ""
      property string sortBy: "name"
      property bool recursive: false
      property bool enableSlideshow: false
      property int slideshowInterval: 5
    }

    property JsonObject ui: JsonObject {
      property string font: defaultTextMetrics.font.family
      property JsonObject bar: JsonObject {
        property real opacity: 0.8
        property real height: 8
        property real fontSize: 12
        property real sectionPadding: 2
        property real widgetSpacing: 1
        property real bottomPadding: 2
      }
      property real frameThickness: 2
      property JsonObject tooltip: JsonObject {
        property real opacity: 0.8
      }
      property JsonObject panel: JsonObject {
        property real opacity: 0.8
      }
      property JsonObject popup: JsonObject {
        property JsonObject contextMenu: JsonObject {
          property real opacity: 0.8
        }
      }
    }

    property JsonObject tooltip: JsonObject {
      property int ttl: 300
    }

    property JsonObject notification: JsonObject {
      property bool isOverlay: true
      property int defaultTTL: 5
      property int lowUrgencyTTL: 3
      property int criticalUrgencyTTL: 8
      property real backgroundOpacity: 0.8
      property int maximumLineCount: 5
      property int maximumCharLength: 120
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

    property JsonObject lockScreen: JsonObject {
      property real backgroundBlur: 0.6
      property real backgroundTint: 0.6
    }

    property JsonObject idle: JsonObject {
      property bool enabled: false
      property int suspendAfter: 30
    }

    property JsonObject bar: JsonObject {
      property JsonObject widgets: JsonObject {
        property list<var> left: []
        property list<var> center: []
        property list<var> right: []
      }
    }
  }

  readonly property alias data: settingsAdapter

  Timer {
    id: reloadDebounceTimer
    running: false
    interval: Theme.timerDebounce
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
    interval: Theme.timerDebounceLong
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
