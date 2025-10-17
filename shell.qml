import QtQuick
import Quickshell
import qs.osd

ShellRoot {
  OSD {}

  Variants {
    model: Quickshell.screens;
  }
}
