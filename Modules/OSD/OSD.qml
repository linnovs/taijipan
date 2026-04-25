import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Services
import qs.Commons

Loader {
  id: root

  active: false

  enum Type {
    Volume
  }

  property bool initialized: false
  property int currentType: -1

  function getIcon() {
    switch (root.currentType) {
    case OSD.Type.Volume:
      if (AudioService.muted || AudioService.volume <= 0.005)
        return "audio-volume-muted";
      if (AudioService.volume >= 0.6)
        return "audio-volume-high";
      if (AudioService.volume >= 0.3)
        return "audio-volume-medium";
      return "audio-volume-low";
    }
    return "osd-rotate-normal";
  }

  function getPercentage() {
    switch (root.currentType) {
    case OSD.Type.Volume:
      return AudioService.volume ?? 0.0;
    }
    return 0.0;
  }

  Timer {
    interval: 2000
    running: true
    onTriggered: {
      root.initialized = true;
    }
  }

  Timer {
    id: deactiveTimer
    interval: Theme.animationNormal + Theme.animationBuffer
    onTriggered: {
      root.active = false;
    }
  }

  sourceComponent: PanelWindow {
    anchors.top: true
    anchors.right: true
    anchors.bottom: true
    anchors.left: true

    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.exclusiveZone: ExclusionMode.Ignore
    WlrLayershell.namespace: "taijipan-osd-" + (screen?.name || "unknown")

    mask: Region {}

    OSDItem {
      id: osdItem
      icon: root.getIcon()
      percentage: root.getPercentage()
    }

    Timer {
      id: autoHideTimer
      interval: Settings.data.osd.autoDismissTimeout
      onTriggered: {
        hideOSD();
      }
    }

    function showOSD() {
      autoHideTimer.stop();
      osdItem.show();
      autoHideTimer.restart();
    }

    function hideOSD() {
      osdItem.hide();
      deactiveTimer.restart();
    }
  }

  function activeAndShow(type) {
    if (!root.initialized)
      return;
    if (!root.active)
      root.active = true;

    currentType = type;
    deactiveTimer.stop();

    if (root.item) {
      root.item.showOSD(type);
    } else {
      Qt.callLater(() => {
        if (root.item)
          root.item.showOSD(type);
      });
    }
  }

  Connections {
    target: AudioService.initialized ? AudioService : null
    function onVolumeChanged() {
      activeAndShow(OSD.Type.Volume);
    }
    function onMutedChanged() {
      activeAndShow(OSD.Type.Volume);
    }
  }
}
