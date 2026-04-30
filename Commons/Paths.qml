pragma Singleton
import QtCore
import QtQuick
import Quickshell

Singleton {
  id: root

  readonly property url home: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
  readonly property url pictures: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]

  readonly property string shellName: "taijipan"
  readonly property url data: `${StandardPaths.standardLocations(StandardPaths.GenericDataLocation)[0]}/${shellName}`
  readonly property url state: `${StandardPaths.standardLocations(StandardPaths.GenericStateLocation)[0]}/${shellName}`
  readonly property url cache: `${StandardPaths.standardLocations(StandardPaths.GenericCacheLocation)[0]}/${shellName}`
  readonly property url config: `${StandardPaths.standardLocations(StandardPaths.GenericConfigLocation)[0]}/${shellName}`

  readonly property url imagecache: `${cache}/images`

  readonly property url scripts: `${Quickshell.shellDir}/scripts`
  readonly property url assets: `${Quickshell.shellDir}/assets`
  readonly property url sounds: `${assets}/sounds`
  readonly property url icons: `${assets}/icons`

  function stringify(path: url): string {
    return path.toString().replace(/%20/g, " ");
  }

  function isFileUrl(path: string): bool {
    return path.startsWith("file://");
  }

  function isRelativePath(path: string): bool {
    return !isFileUrl(path) && !path.startsWith("/");
  }

  function strip(path: url): string {
    return stringify(path).replace("file://", "");
  }

  function toFileUrl(path: string): url {
    return path.startsWith("file://") ? path : "file://" + path;
  }

  function baseName(path: string): string {
    path = strip(path);
    const parts = path.split("/");
    return parts[parts.length - 1];
  }

  function joinDir(...parts): string {
    return parts.map(part => strip(part)).join("/");
  }

  readonly property string homeDir: strip(home)
  function homePath(...parts): string {
    return joinDir(homeDir, ...parts);
  }

  function replaceHomeWithTilde(path: string): string {
    path = strip(path);
    if (path.startsWith(homeDir)) {
      return "~" + path.slice(homeDir.length);
    }
    return path;
  }

  readonly property string picturesDir: strip(pictures)
  function picturePath(...parts): string {
    return joinDir(picturesDir, ...parts);
  }

  readonly property string dataDir: strip(data)
  function dataPath(...parts): string {
    return joinDir(dataDir, ...parts);
  }

  readonly property string stateDir: strip(state)
  function statePath(...parts): string {
    return joinDir(stateDir, ...parts);
  }

  readonly property string cacheDir: strip(cache)
  function cachePath(...parts): string {
    return joinDir(cacheDir, ...parts);
  }

  readonly property string configDir: strip(config)
  function configPath(...parts): string {
    return joinDir(configDir, ...parts);
  }

  readonly property string imagecacheDir: strip(imagecache)
  function imagecachePath(...parts): string {
    return joinDir(imagecacheDir, ...parts);
  }

  readonly property string scriptsDir: strip(scripts)
  function scriptPath(...parts): string {
    return joinDir(scriptsDir, ...parts);
  }

  readonly property string assetsDir: strip(assets)
  function assetPath(...parts): string {
    return joinDir(assetsDir, ...parts);
  }

  readonly property string soundsDir: strip(sounds)
  function soundPath(...parts): string {
    return joinDir(soundsDir, ...parts);
  }

  readonly property string iconsDir: strip(icons)
  function iconPath(...parts): string {
    return joinDir(iconsDir, ...parts);
  }
}
