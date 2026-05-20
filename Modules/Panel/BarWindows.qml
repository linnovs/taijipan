import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Modules.Bar
import qs.Commons

PanelWindow {
  id: root

  property bool contentLoaded: false

  Component.onCompleted: {
    contentLoaded = true;
  }

  WlrLayershell.layer: WlrLayer.Top
  WlrLayershell.exclusionMode: ExclusionMode.Ignore
  WlrLayershell.namespace: "taijipan-bar-" + (screen?.name || "unknown")
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

  color: "transparent"

  anchors.top: true
  anchors.right: true
  anchors.bottom: false
  anchors.left: true

  implicitWidth: screen.width
  implicitHeight: Theme.barHeight + Theme.frameThickness

  Loader {
    anchors.fill: parent
    active: root.contentLoaded

    sourceComponent: Item {
      anchors.fill: parent
      opacity: 0

      Behavior on opacity {
        NumberAnimation {
          duration: Theme.animationFast
          easing.type: Easing.OutQuad
        }
      }

      Component.onCompleted: {
        opacity = 1;
      }

      Bar {
        anchors.fill: parent
        screen: root.screen
      }
    }
  }
}
