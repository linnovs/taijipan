pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.Services

Variants {
  id: osd
  model: Quickshell.screens

  enum Type {
    Volume,
    NumLock,
    CapsLock,
    ScrollLock
  }

  delegate: Loader {
    id: root
    required property ShellScreen modelData
    active: false

    property bool startupComplete: false
    property int currentOSDType: -1

    readonly property real currentVolume: AudioService.volume
    readonly property bool isMuted: AudioService.muted

    function getIcon() {
      switch (currentOSDType) {
      case OSD.Type.Volume:
        return AudioService.iconName;
      case OSD.Type.NumLock:
        return LockKeysService.numLockState ? "numlock-on" : "numlock-off";
      default:
        return "action-unavailable";
      }
    }

    function getPercentage() {
      switch (currentOSDType) {
      case OSD.Type.Volume:
        return isMuted ? 0 : currentVolume;
      default:
        return 0;
      }
    }

    function getDisplayText() {
      switch (currentOSDType) {
      case OSD.Type.Volume:
        return "";
      case OSD.Type.NumLock:
        return LockKeysService.numLockState ? qsTr("Num Lock On") : qsTr("Num Lock Off");
      case OSD.Type.CapsLock:
        return LockKeysService.capsLockState ? qsTr("Caps Lock On") : qsTr("Caps Lock Off");
      case OSD.Type.ScrollLock:
        return LockKeysService.scrollLockState ? qsTr("Scroll Lock On") : qsTr("Scroll Lock Off");
      default:
        return "";
      }
    }

    function showOSD(type) {
      if (!startupComplete) return;

      currentOSDType = type;

      if (!root.active) root.active = true;

      if (root.item) {
        root.item.showOSD();
      } else {
        Qt.callLater(() => {
          if (root.item) root.item.showOSD();
        })
      }
    }

    Timer {
      id: startupTimer
      interval: 2 * 1000
      running: true
      onTriggered: {
        root.startupComplete = true;
      }
    }

    Component.onCompleted: {
      LockKeysService.register("osd-" + (modelData?.name || "unknown"));
    }

    Component.onDestruction: {
      LockKeysService.unregister("osd-" + (modelData?.name || "unknown"));
    }

    Connections {
      target: AudioService
      function onVolumeChanged() {
        root.showOSD(OSD.Type.Volume);
      }
      function onMutedChanged() {
        root.showOSD(OSD.Type.Volume);
      }
    }

    Connections {
      target: LockKeysService
      function onNumLockChanged() {
        root.showOSD(OSD.Type.NumLock);
      }
      function onCapsLockChanged() {
        root.showOSD(OSD.Type.CapsLock);
      }
      function onScrollLockChanged() {
        root.showOSD(OSD.Type.ScrollLock);
      }
    }

    sourceComponent: OSDPanel {
      currentOSDType: root.currentOSDType
      iconName: root.getIcon()
      percentage: root.getPercentage()
      displayText: root.getDisplayText()
      onHidden: {
        root.currentOSDType = -1;
        root.active = false;
      }
    }
  }
}
