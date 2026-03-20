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
    CapLock,
    NumLock
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

    sourceComponent: PanelWindow {
      id: panel
      screen: root.modelData
      margins.bottom: Theme.marginL
      anchors.bottom: true

      implicitWidth: Theme.osdWidth
      implicitHeight: Theme.osdHeight
      color: "transparent"

      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.namespace: "taijipan-osd-" + (screen?.name || "unknown")
      WlrLayershell.exclusionMode: ExclusionMode.Ignore
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

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
            panel.margins.bottom = Theme.marginL
            osdItem.visible = true;
            osdItem.opacity = 1.0;
            osdItem.scale = 1.0;
            hideTimer.start();
          }
        }

        Timer {
          id: hideTimer
          interval: 3 * 1000
          onTriggered: osdItem.hide()
        }

        Timer {
          id: visibilityTimer
          interval: Theme.animationNormal
          onTriggered: {
            osdItem.visible = false;
            root.currentOSDType = -1;
            root.active = false;
          }
        }

        Rectangle {
          id: background
          anchors.fill: parent
          anchors.margins: Theme.spacing
          radius: Theme.radiusM
          color: Qt.alpha(Theme.overlay, 0.95)
          border.color: Qt.alpha(Theme.mauve, 0.95)
          border.width: 2
        }

        DropShadow {
          anchors.fill: background
          source: background
          autoPaddingEnabled: true
        }

        RowLayout {
          anchors.fill: background
          anchors.leftMargin: Theme.marginM
          anchors.rightMargin: Theme.marginM
          spacing: Theme.marginS

          TextMetrics {
            id: percentageMetrics
            font.family: Theme.fontFamily
            font.pointSize: Theme.fontSizeS
            text: "150%"
          }

          ColorImageIcon {
            width: Theme.iconSizeL
            height: Theme.iconSizeL
            name: root.getIcon()
            color: Theme.text
          }

          Rectangle {
            visible: root.currentOSDType !== OSD.Type.NumLock && root.currentOSDType !== OSD.Type.CapLock
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            height: Theme.spacing * 2
            radius: height / 2
            color: Theme.overlaySecondary

            Rectangle {
              anchors.left: parent.left
              anchors.top: parent.top
              anchors.bottom: parent.bottom
              width: parent.width * root.currentVolume
              radius: parent.radius
              color: Theme.text

              Behavior on width {
                NumberAnimation {
                  duration: Theme.animationNormal
                  easing.type: Easing.InOutQuad
                }
              }
            }
          }

          Text {
            visible: root.currentOSDType !== OSD.Type.NumLock && root.currentOSDType !== OSD.Type.CapLock
            text: `${Math.round(root.currentVolume * 100)}%`.padStart(4)
            color: Theme.text
            font.family: Theme.fontFamily
            font.pointSize: Theme.fontSizeS
            font.weight: Font.Medium
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: false
            Layout.preferredWidth: Math.ceil(percentageMetrics.width)
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
          osdItem.opacity = 0;
          osdItem.scale = 0.85;
          visibilityTimer.start();
        }
      }

      function showOSD() {
        osdItem.show()
      }
    }
  }
}
