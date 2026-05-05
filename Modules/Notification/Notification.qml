import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.Services
import qs.Commons

Loader {
  id: root

  property ListModel popups: NotificationService.popups

  active: false

  Connections {
    target: popups
    function onCountChanged() {
      root.active = popups.count > 0;
    }
  }

  sourceComponent: PanelWindow {
    id: notifyWindow

    WlrLayershell.layer: Settings.data.notification.isOverlay ? WlrLayer.Overlay : WlrLayer.Top
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "taijipan-notification-popup-" + (screen?.name || "unknown")

    anchors.top: true
    anchors.right: true
    anchors.bottom: true
    anchors.left: true
    color: "transparent"

    ColumnLayout {
      id: popupContainer

      anchors.horizontalCenter: parent.horizontalCenter
      y: Theme.barHeight + Theme.marginXS
      spacing: Theme.marginXS

      Repeater {
        id: popupRepeater
        model: popups
        NotificationPopup {}
      }

      Behavior on implicitHeight {
        SpringAnimation {
          spring: 2.0
          damping: 0.4
          epsilon: 0.01
          mass: 0.8
        }
      }
    }

    Connections {
      target: NotificationService
      function onNotificationExpiring(id) {
        for (let i = 0; i < popupRepeater.count; i++) {
          const popup = popupRepeater.itemAt(i);
          if (popup.notificationId === id && !popup.dismissing) {
            popup.dismiss();
          }
        }
      }
    }

    mask: Region {
      id: clickableMask

      x: 0
      y: 0
      width: notifyWindow.width
      height: notifyWindow.height
      intersection: Intersection.Xor

      Region {
        id: popupRegion
        x: popupContainer.x
        y: popupContainer.y
        width: popupContainer.implicitWidth
        height: popupContainer.implicitHeight
        intersection: Intersection.Subtract
      }

      regions: [popupRegion]
    }
  }
}
