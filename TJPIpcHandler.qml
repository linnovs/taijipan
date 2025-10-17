import QtQuick
import Quickshell
import Quickshell.Io

Item {
  id: root
  required property var powermenuLoader

  IpcHandler {
    target: "taijipan"

    function openPowermenu(): void {
      root.powermenuLoader.active = true;
    }
  }
}
