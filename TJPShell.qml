pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.Powermenu
import qs.OSD
import qs.Lock

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
