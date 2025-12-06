pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import Quickshell.Widgets

Item {
  id: root

  property real volume: Pipewire.defaultAudioSink?.audio.volume ?? 0
  property string iconName: "system-audio-volume-medium-symbolic"
  property bool shouldShowOSD: false

  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink]
  }

  Connections {
    target: Pipewire.defaultAudioSink.audio

    function changeIcon() {
      if (Pipewire.defaultAudioSink.audio.muted) {
        root.iconName = "audio-volume-muted-symbolic";
        return ;
      }

      if (root.volume >= 0.5) root.iconName = "audio-volume-high-symbolic";
      else root.iconName = "audio-volume-medium-symbolic";
    }

    function onVolumeChanged() {
      root.shouldShowOSD = true;
      changeIcon();
      hideTimer.restart();
    }

    function onMutedChanged() {
      root.shouldShowOSD = true;
      changeIcon();
      hideTimer.restart();
    }
  }

  Timer {
    id: hideTimer

    interval: 1000
    onTriggered: root.shouldShowOSD = false
  }

  LazyLoader {
    active: root.shouldShowOSD

    PanelWindow {
      anchors.bottom: true
      margins.bottom: screen.height / 5
      exclusiveZone: 0
      implicitWidth: 400
      implicitHeight: 70
      color: "transparent"

      WlrLayershell.layer: WlrLayer.Overlay

      mask: Region {
      }

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
            source: Quickshell.iconPath(root.iconName)
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

              implicitWidth: Math.min(parent.width, parent.width * root.volume)
              radius: height / 2
            }
          }

          Text {
            Layout.alignment: Qt.AlignVCenter
            Layout.minimumWidth: 45

            text: `${ Math.round(root.volume * 100) }%`.padStart(4)
            font.bold: true
            color: "#ffffff"
          }
        }
      }
    }
  }
}
