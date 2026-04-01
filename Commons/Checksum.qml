pragma Singleton

import QtQuick
import Quickshell
import "./hash.js" as Hash

Singleton {
  id: root

  function sha256(data) {
    return Hash.sha256(data)
  }
}
