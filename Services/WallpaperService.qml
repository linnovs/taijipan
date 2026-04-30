pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons

Singleton {
  id: root

  property bool initialized: false
  property string wallpaperStateFile: ""
  property var currentWallpapers: ({})
  property var usedRandomWallpapers: []
  property string defaultWallpaper: Paths.assetPath("default-wallpaper.jpg")
  property var wallpaperList: []
  property QtObject runningProcess

  // Emitted when the current wallpaper for a screen changes. Provides the screen name and the new wallpaper path.
  signal wallpaperChanged(string screen, string wallpaper)
  // Emitted when a wallpaper has finished processing and is ready to be displayed. Provides the screen name, the final
  // wallpaper path, and the cached thumbnail path (if applicable).
  signal postWallpaperProcess(string screen, string wallpaper, string cached)

  function _updateCurrentWallpapers() {
    Quickshell.screens.forEach(screen => {
      const screenName = screen.name;
      if (currentWallpapers[screenName])
        return; // keep existing wallpaper if already set
      currentWallpapers[screenName] = defaultWallpaper;
    });
    saveStateDebounce.restart();
  }

  FileView {
    id: wallpaperState
    printErrors: false
    watchChanges: false

    adapter: JsonAdapter {
      id: wallpaperStateAdapter
      property var wallpapers: ({})
      property list<string> usedRandomWallpapers: []
    }

    onLoaded: {
      root.currentWallpapers = wallpaperStateAdapter.wallpapers || {};
      root.usedRandomWallpapers = wallpaperStateAdapter.usedRandomWallpapers || [];
      root._updateCurrentWallpapers();
      root.initialized = true;
    }

    onLoadFailed: error => {
      root._updateCurrentWallpapers();
      Logger.d("WallpaperService", "No existing wallpaper state found, starting fresh");
      root.initialized = true;
    }
  }

  Timer {
    id: saveStateDebounce
    interval: 500
    onTriggered: {
      wallpaperStateAdapter.wallpapers = root.currentWallpapers;
      wallpaperStateAdapter.usedRandomWallpapers = root.usedRandomWallpapers;
      wallpaperState.writeAdapter();
      Logger.d("WallpaperService", "Saved wallpapers to state file");
    }
  }

  Component {
    id: scanProcess
    Process {
      stdout: StdioCollector {}
      stderr: StdioCollector {}
    }
  }

  function _handleScanResults(directory, exitCode) {
    Logger.d("WallpaperService", "Finished wallpaper scan for directory", Paths.replaceHomeWithTilde(directory));

    if (exitCode === 0) {
      let lines = runningProcess.stdout.text.split("\n");
      let parsedFiles = [];

      for (let i = 0; i < lines.length; i++) {
        let line = lines[i].trim();
        if (line === "")
          continue;

        let parts = line.split("|");
        if (parts.length !== 2)
          continue;

        parsedFiles.push({
          timestamp: parseInt(parts[0]),
          filePath: parts[1],
          fileName: Paths.baseName(parts[1])
        });
      }

      const sortBy = Settings.data.wallpaper.sortBy || "name";
      if (sortBy === "random") { // fisher-yates shuffle
        for (let i = parsedFiles.length - 1; i > 0; i--) {
          const j = Math.floor(Math.random() * (i + 1));
          [parsedFiles[i], parsedFiles[j]] = [parsedFiles[j], parsedFiles[i]];
        }
      } else {
        parsedFiles.sort((a, b) => {
          switch (sortBy) {
          case "date_desc":
            return b.timestamp - a.timestamp;
          case "date_asc":
            return a.timestamp - b.timestamp;
          case "name_desc":
            return b.fileName.localeCompare(a.fileName);
          // name_asc
          default:
            return a.fileName.localeCompare(b.fileName);
          }
        });
      }

      wallpaperList = parsedFiles.map(file => file.filePath);
      Logger.i("WallpaperService", "Found", wallpaperList.length, "wallpapers in directory", Paths.replaceHomeWithTilde(directory));
    } else {
      Logger.w("WallpaperService", "Wallpaper scan process exited with code", exitCode, "for directory", Paths.replaceHomeWithTilde(directory));
      Logger.w("WallpaperService", "- Error output from scan process:");
      runningProcess.stderr.text.split("\n").forEach(line => {
        if (line.trim() !== "")
          Logger.w("WallpaperService", ` - ${line}`);
      });
      Logger.w("WallpaperService", "- Above error may be expected if the directory doesn't exist or is inaccessible");
    }

    runningProcess.destroy();
    runningProcess = null;
  }

  function _scanDirectory(directory) {
    if (!directory || directory === "") {
      Logger.w("WallpaperService", "No directory provided for scanning");
      return;
    }

    if (runningProcess) {
      Logger.d("WallpaperService", "Scan already in progress, cancelling previous scan");
      runningProcess.running = false;
      runningProcess.destroy();
      runningProcess = null;
    }

    let filters = ImageCacheService.supportedImageFormats;
    let findCommand = ["find", "-L", directory, "-type", "f"];

    if (!Settings.data.wallpaper.recursive) {
      findCommand.push("-maxdepth", "1", "-mindepth", "1");
    }

    const filterArgs = [];
    for (let i = 0; i < filters.length; i++) {
      if (i > 0)
        filterArgs.push("-o");
      filterArgs.push("-iname", `*.${filters[i]}`);
    }

    findCommand.push("(", ...filterArgs, ")", "-printf", "%T@|%p\\n");

    runningProcess = scanProcess.createObject(root, {
      command: findCommand
    });
    runningProcess.exited.connect(_handleScanResults.bind(null, directory));
    Logger.d("WallpaperService", "Started wallpaper scan for directory", Paths.replaceHomeWithTilde(directory));
    runningProcess.running = true;
  }

  function _setWallpaperForScreen(screenName, wallpaperPath) {
    if (wallpaperPath === "" || wallpaperPath === undefined) {
      return;
    }

    if (screenName === "" || screenName === undefined) {
      Logger.w("WallpaperService", "Attempted to set wallpaper with invalid screen name:", screenName);
      return;
    }

    const currentPath = currentWallpapers[screenName];
    if (currentPath === wallpaperPath) {
      Logger.d("WallpaperService", "Wallpaper for screen", screenName, "is already set to", Paths.replaceHomeWithTilde(wallpaperPath));
      return;
    }

    if (wallpaperList.length > 0 && !wallpaperList.includes(wallpaperPath)) {
      Logger.w("WallpaperService", "Attempted to set wallpaper to a path that is not in the current wallpaper list:", Paths.replaceHomeWithTilde(wallpaperPath));
      return;
    }

    currentWallpapers[screenName] = wallpaperPath;
    saveStateDebounce.restart();
    root.wallpaperChanged(screenName, wallpaperPath);

    if (slideshowTimer.running)
      slideshowTimer.restart();
  }

  function changeWallpaper(path) {
    let allScreenNames = new Set(Object.keys(currentWallpapers));
    for (let i = 0; i < Quickshell.screens.length; i++) {
      allScreenNames.add(Quickshell.screens[i].name);
    }
    allScreenNames.forEach(name => _setWallpaperForScreen(name, path));
  }

  function setNextWallpaper() {
    if (wallpaperList.length === 0) {
      Logger.d("WallpaperService", "No wallpapers available to set for slideshow");
      return;
    }

    let used = usedRandomWallpapers || [];
    let wallpaperSet = new Set(wallpaperList);
    used = used.filter(wp => wallpaperSet.has(wp)); // remove any wallpapers that are no longer available

    let unused = wallpaperList.filter(wp => !used.includes(wp));
    if (unused.length === 0) {
      var lastUsed = used.length > 0 ? used[used.length - 1] : "";
      used = lastUsed ? [lastUsed] : [];
      unused = wallpaperList.filter(wp => !used.includes(wp));

      // edge case when only single wallpaper is available
      if (unused.length === 0) {
        unused = wallpaperList.slice();
      }
      Logger.d("WallpaperService", "All wallpapers have been used for slideshow, resetting used list");
    }

    let idx = Math.floor(Math.random() * unused.length);
    let picked = unused[idx];
    used.push(picked);
    usedRandomWallpapers = used;

    saveStateDebounce.restart();
    changeWallpaper(picked);
  }

  Timer {
    id: slideshowTimer
    interval: Settings.data.wallpaper.slideshowInterval * 1000
    running: Settings.data.wallpaper.enableSlideshow
    repeat: true
    onTriggered: setNextWallpaper()
    triggeredOnStart: false
  }

  function refreshWallpapers() {
    if (!ImageCacheService.initialized) {
      Qt.callLater(refreshWallpapers);
      return;
    }

    if (Settings.data.wallpaper.directory === "") {
      Logger.i("WallpaperService", "No wallpaper directory set, skipping wallpaper refresh");
      return;
    }

    Logger.i("WallpaperService", "Refreshing wallpapers from directory", Paths.replaceHomeWithTilde(Settings.data.wallpaper.directory));
    _scanDirectory(Settings.data.wallpaper.directory);
  }

  function init() {
    Logger.i("WallpaperService", "Loaded wallpaper service");

    Qt.callLater(() => {
      if (typeof Settings !== "undefined" && Paths.stateDir) {
        wallpaperStateFile = Paths.statePath("wallpaper.json");
        wallpaperState.path = wallpaperStateFile;
      }
    });

    Logger.d("WallpaperService", "Initial wallpaper scan");
    Qt.callLater(refreshWallpapers);
  }

  Connections {
    target: Settings.data.wallpaper
    function onDirectoryChanged() {
      Logger.d("WallpaperService", "Refreshing wallpaper list due to directory changed to", Paths.replaceHomeWithTilde(Settings.data.wallpaper.directory));
      refreshWallpapers();
    }
    function onSortByChanged() {
      Logger.d("WallpaperService", "Refreshing wallpaper list due to sort method changed to", Settings.data.wallpaper.sortBy);
      refreshWallpapers();
    }
    function onEnableSlideshowChanged() {
      Logger.d("WallpaperService", "Wallpaper slideshow", Settings.data.wallpaper.enableSlideshow ? "enabled" : "disabled");
      if (Settings.data.wallpaper.enableSlideshow) {
        slideshowTimer.restart();
      } else {
        slideshowTimer.stop();
      }
    }
    function onSlideshowIntervalChanged() {
      Logger.d("WallpaperService", "Wallpaper slideshow interval changed to", Settings.data.wallpaper.slideshowInterval, "seconds");
      slideshowTimer.interval = Settings.data.wallpaper.slideshowInterval * 1000;
      if (Settings.data.wallpaper.enableSlideshow) {
        slideshowTimer.restart();
      }
    }
  }
}
