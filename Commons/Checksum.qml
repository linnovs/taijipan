pragma Singleton
import "./hash.js" as Hash
import QtQuick
import Quickshell

Singleton {
  id: root

  function sha256(data) {
    return Hash.sha256(data);
  }
}
