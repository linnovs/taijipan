pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.Services
import qs.Common
import qs.Widgets

Item {
  id: root

  property bool shouldShowOSD: false

  function show() {
    shouldShowOSD = true;
    hideTimer.restart();
  }

  Connections {
    target: AudioService

    function onVolumeChanged() { root.show() }
    function onMutedChanged() { root.show() }
  }

  Timer {
    id: hideTimer

    interval: 3000
    onTriggered: root.shouldShowOSD = false
  }

  LazyLoader {
    active: root.shouldShowOSD

    PanelWindow {
      anchors.bottom: true
      margins.bottom: screen.height / 5
      exclusiveZone: 0
      implicitWidth: Theme.osdWidth
      implicitHeight: Theme.osdHeight
      color: "transparent"

      WlrLayershell.layer: WlrLayer.Overlay

      mask: Region {
      }

      Rectangle {
        anchors.fill: parent
        radius: Theme.radiusRound
        color: Theme.overlay
        opacity: 0.9

        RowLayout {
          anchors {
            fill: parent
            leftMargin: 10
            rightMargin: 15
          }

          ColorImageIcon {
            width: Theme.iconSizeL
            height: Theme.iconSizeL
            name: AudioService.iconName
            color: Theme.text
          }

          Rectangle {
            Layout.fillWidth: true

            implicitHeight: Theme.spacing * 5
            radius: height / 2
            color: Theme.overlay

            Rectangle {
              anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
              }

              implicitWidth: Math.min(parent.width, parent.width * AudioService.volume)
              radius: Theme.radiusRound
              color: Theme.text
            }
          }

          Text {
            Layout.alignment: Qt.AlignVCenter
            Layout.minimumWidth: 45

            text: `${ Math.round(AudioService.volume * 100) }%`.padStart(4)
            font.bold: true
            color: Theme.text
          }
        }
      }
    }
  }
}
