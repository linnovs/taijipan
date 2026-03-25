import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Widgets
import qs.Commons

PanelWindow {
  id: root
  margins.top: 0 // qmllint disable
  anchors.top: true

  property int currentOSDType: -1
  property string iconName: ""
  property real percentage: 0.0
  property string displayText: ""

  readonly property int displayDuration: 3 * 1000

  implicitWidth: Theme.osdWidth
  implicitHeight: Theme.osdHeight
  color: "transparent"

  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.namespace: "taijipan-osd-" + (screen?.name || "unknown")
  WlrLayershell.exclusionMode: ExclusionMode.Ignore
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

  signal hidden

  Behavior on margins.top {
    NumberAnimation {
      duration: Theme.animationSlow
      easing.type: Easing.Linear
    }
  }

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
        root.margins.top = Theme.barHeight + Theme.marginL; // qmllint disable
        hideTimer.start();
      }
    }

    Timer {
      id: hideTimer
      interval: root.displayDuration + Theme.animationNormal
      onTriggered: osdItem.hide()
    }

    Timer {
      id: visibilityTimer
      interval: Theme.animationSlow + 50
      onTriggered: {
        osdItem.visible = false;
        root.hidden();
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
      displayText: {
        if (root.displayText === "") {
          return `${Math.round(root.percentage * 100)}%`.padStart(4);
        }
        return root.displayText;
      }
    }

    function show() {
      hideTimer.stop();
      visibilityTimer.stop();
      showDelayTimer.start();
    }

    function hide() {
      hideTimer.stop();
      visibilityTimer.stop();
      root.margins.top = -root.height; // qmllint disable
      osdItem.opacity = 0;
      osdItem.scale = 0.85;
      visibilityTimer.start();
    }
  }

  function showOSD() {
    osdItem.show()
  }
}
