pragma ComponentBehavior: Bound

import QtQuick
import qs.Powermenu
import qs.OSD
import qs.Lock
import qs.TJPBar

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

  TJPBar {}
}
