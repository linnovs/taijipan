pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets

Scope {
  id: volumeOSD

  PwObjectTracker {
    objects: [ Pipewire.defaultAudioSink ]
  }

  property real volume: Pipewire.defaultAudioSink?.audio.volume ?? 0
  property string iconName

  Connections {
    target: Pipewire.defaultAudioSink?.audio

    function changeIcon() {
      if (Pipewire.defaultAudioSink?.audio.muted) {
        volumeOSD.iconName = "audio-volume-muted-symbolic";
        return;
      }

      if (volumeOSD.volume >= 2/3) {
        volumeOSD.iconName = "audio-volume-high-symbolic";
      } else if (volumeOSD.volume >= 1/3) {
        volumeOSD.iconName = "audio-volume-medium-symbolic";
      } else {
        volumeOSD.iconName = "audio-volume-low-symbolic";
      }
    }

    function onVolumeChanged() {
      volumeOSD.shouldShowOSD = true;
      changeIcon();
      hideTimer.restart();
    }

    function onMutedChanged() {
      volumeOSD.shouldShowOSD = true;
      changeIcon();
      hideTimer.restart();
    }
  }

  property bool shouldShowOSD: false

  Timer {
    id: hideTimer
    interval: 1000
    onTriggered: volumeOSD.shouldShowOSD = false
  }

  LazyLoader {
    active: volumeOSD.shouldShowOSD

    PanelWindow {
      anchors.bottom: true
      margins.bottom: screen.height / 5
      exclusiveZone: 0

      implicitWidth: 400
      implicitHeight: 70
      color: "transparent"

      mask: Region {}

      Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: "#b21e1e2e"

        RowLayout {
          anchors {
            fill: parent
            leftMargin: 10
            rightMargin: 15
          }

          IconImage {
            implicitSize: 50
            source: Quickshell.iconPath(volumeOSD.iconName)
          }

          Rectangle {
            Layout.fillWidth: true

            implicitHeight: 20
            radius: height / 2
            color: "#50ffffff"

            Rectangle {
              anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
              }

              implicitWidth: Math.min(parent.width, parent.width * volumeOSD.volume)
              radius: height / 2
            }
          }
        }
      }
    }
  }
}
