pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.powermenu
import qs.osd

Item {
  id: root

  Loader {
    id: powermenuLoader
    active: false
    sourceComponent: Powermenu {
      onClose: {
        powermenuLoader.active = false;
      }
    }
  }

  TJPIpcHandler {
    powermenuLoader: powermenuLoader
  }

  VolumeOSD {}
}
