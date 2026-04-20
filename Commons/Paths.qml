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

  function strip(path: url): string {
    return stringify(path).replace("file://", "");
  }

  function toFileUrl(path: string): url {
    return path.startsWith("file://") ? path : "file://" + path;
  }

  function joinDir(...parts): string {
    return parts.map(part => strip(part)).join("/");
  }

  readonly property string homeDir: strip(home)
  readonly property string picturesDir: strip(pictures)
  readonly property string dataDir: strip(data)
  readonly property string stateDir: strip(state)
  readonly property string cacheDir: strip(cache)
  readonly property string configDir: strip(config)
  readonly property string imagecacheDir: strip(imagecache)
  readonly property string scriptsDir: strip(scripts)
  readonly property string assetsDir: strip(assets)
  readonly property string soundsDir: strip(sounds)
  readonly property string iconsDir: strip(icons)
}
