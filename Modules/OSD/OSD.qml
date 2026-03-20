pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.Services
import qs.Widgets
import qs.Commons

Variants {
  id: osd
  model: Quickshell.screens

  enum Type {
    Volume,
    LockKey
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

    function showOSD(type) {
      if (!startupComplete) return;

      currentOSDType = type;

      if (!root.active) root.active = true;

      if (root.item) {
        root.item.showOSD(); // qmllint disable missing-property
      } else {
        Qt.callLater(() => {
          if (root.item) root.item.showOSD(); // qmllint disable missing-property
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

    Connections {
      target: AudioService
      function onVolumeChanged() {
        root.showOSD(OSD.Type.Volume);
      }
      function onMutedChanged() {
        root.showOSD(OSD.Type.Volume);
      }
    }

    sourceComponent: OSDPanel {
      currentOSDType: root.currentOSDType
      iconName: root.getIcon()
      percentage: root.getPercentage()
      onHidden: {
        root.currentOSDType = -1;
        root.active = false;
      }
    }
  }
}
