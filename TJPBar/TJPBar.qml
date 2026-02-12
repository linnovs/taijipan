pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

Item {
  id: root

  Variants {
    model: Quickshell.screens

    delegate: TJPBarWindow {}
  }
}
