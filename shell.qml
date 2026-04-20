import QtQuick
import Quickshell
import qs.Commons

ShellRoot {
  Component.onCompleted: {
    Logger.i("Shell", "         ☴     ☲     ☷");
    Logger.i("Shell", "         ☳     ☯      ☱");
    Logger.i("Shell", "         ☶     ☵     ☰");
    Logger.i("Shell", "Yin and Yang in One. Tai Ji Pan.");
  }

  Connections {
    target: Quickshell
    function onReloadCompleted() {
      Quickshell.inhibitReloadPopup();
    }
  }
}
