import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Widgets
import qs.Commons

PanelWindow {
  id: root
  margins.top: Theme.barHeight + Theme.marginM
  anchors.top: true

  property int currentOSDType: -1
  property string iconName: ""
  property real percentage: 0.0

  readonly property int displayDuration: 3 * 1000

  implicitWidth: Theme.osdWidth
  implicitHeight: Theme.osdHeight
  color: "transparent"

  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.namespace: "taijipan-osd-" + (screen?.name || "unknown")
  WlrLayershell.exclusionMode: ExclusionMode.Ignore
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

  signal hidden

  Item {
    id: osdItem
    anchors.fill: parent
    visible: false
    opacity: 0
    scale: 0.85

    Behavior on opacity {
      NumberAnimation {
        duration: Theme.animationNormal
        easing.type: Easing.InOutQuad
      }
    }

    Behavior on scale {
      NumberAnimation {
        duration: Theme.animationNormal
        easing.type: Easing.InOutQuad
      }
    }

    Timer {
      id: showDelayTimer
      interval: 30
      onTriggered: {
        osdItem.visible = true;
        osdItem.opacity = 1.0;
        osdItem.scale = 1.0;
        hideTimer.start();
      }
    }

    Timer {
      id: hideTimer
      interval: root.displayDuration
      onTriggered: osdItem.hide()
    }

    Timer {
      id: visibilityTimer
      interval: Theme.animationNormal
      onTriggered: {
        osdItem.visible = false;
        hidden();
      }
    }

    Rectangle {
      id: background
      anchors.fill: parent
      anchors.margins: Theme.marginM * 1.5
      radius: Theme.radiusM
      color: Qt.alpha(Theme.base, 0.95)
      border.color: Qt.alpha(Theme.mantle, 0.95)
      border.width: 2
    }

    DropShadow {
      anchors.fill: background
      source: background
      autoPaddingEnabled: true
    }

    OSDContent {
      background: background
      currentOSDType: root.currentOSDType
      iconName: root.iconName
      percentage: root.percentage
    }

    function show() {
      hideTimer.stop();
      visibilityTimer.stop();
      showDelayTimer.start();
    }

    function hide() {
      hideTimer.stop();
      visibilityTimer.stop();
      osdItem.opacity = 0;
      osdItem.scale = 0.85;
      visibilityTimer.start();
    }
  }

  function showOSD() {
    osdItem.show()
  }
}
