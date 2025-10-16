import QtQuick
import Quickshell
import qs.volumeOSD

ShellRoot {
  OSD {}

  Variants {
    model: Quickshell.screens;
  }
}
