pragma Singleton

import QtCore
import QtQuick
import Quickshell

Singleton {
  id: root

  readonly property url home: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
  readonly property url pictures: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]

  readonly property url data: `${StandardPaths.standardLocations(StandardPaths.GenericDataLocation)[0]}/TaiJiPanShell`
  readonly property url state: `${StandardPaths.standardLocations(StandardPaths.GenericStateLocation)[0]}/TaiJiPanShell`
  readonly property url cache: `${StandardPaths.standardLocations(StandardPaths.GenericCacheLocation)[0]}/TaiJiPanShell`
  readonly property url config: `${StandardPaths.standardLocations(StandardPaths.GenericConfigLocation)[0]}/TaiJiPanShell`

  readonly property url imagecache: `${cache}/images`

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
}
