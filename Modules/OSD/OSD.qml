import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Services
import qs.Commons

Loader {
  id: root

  active: false

  enum Type {
    Volume,
    LockKey
  }

  property bool initialized: false
  property int currentType: -1
  property string lockKeyType: ""

  function getIcon() {
    switch (root.currentType) {
    case OSD.Type.Volume:
      if (AudioService.muted)
        return "audio-volume-muted";
      if (AudioService.volume <= 0.005)
        return "audio-volume-low";
      if (AudioService.volume >= 0.5)
        return "audio-volume-high";
      return "audio-volume-medium";
    case OSD.Type.LockKey:
      switch (root.lockKeyType) {
      case "capslock":
        return LockKeyService.capsLockOn ? "caps-lock-on" : "caps-lock-off";
      case "numlock":
        return LockKeyService.numLockOn ? "num-lock-on" : "num-lock-off";
      case "scrolllock":
        return LockKeyService.scrollLockOn ? "scroll-lock-on" : "scroll-lock-off";
      }
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

  function getStatusMessage() {
    switch (root.currentType) {
    case OSD.Type.LockKey:
      switch (root.lockKeyType) {
      case "capslock":
        return LockKeyService.capsLockOn ? "Caps Lock On" : "Caps Lock Off";
      case "numlock":
        return LockKeyService.numLockOn ? "Num Lock On" : "Num Lock Off";
      case "scrolllock":
        return LockKeyService.scrollLockOn ? "Scroll Lock On" : "Scroll Lock Off";
      }
    }
    return "";
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
      statusMessage: root.getStatusMessage()
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

  Component.onCompleted: {
    LockKeyService.registerComponent("osd:lockKey");
  }

  Component.onDestruction: {
    LockKeyService.unregisterComponent("osd:lockKey");
  }

  Connections {
    target: LockKeyService
    function onCapsLockChanged(state) {
      root.lockKeyType = "capslock";
      activeAndShow(OSD.Type.LockKey);
    }
    function onNumLockChanged(state) {
      root.lockKeyType = "numlock";
      activeAndShow(OSD.Type.LockKey);
    }
    function onScrollLockChanged(state) {
      root.lockKeyType = "scrolllock";
      activeAndShow(OSD.Type.LockKey);
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
