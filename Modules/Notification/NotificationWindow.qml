import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Commons

PanelWindow {
  id: notificationWindow

  required property ListModel notifierModel

  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.namespace: "taijipan-notifications-" + (screen?.name || "unknown")
  WlrLayershell.exclusionMode: ExclusionMode.Ignore

  anchors.top: true
  anchors.right: true
  anchors.bottom: false
  anchors.left: false

  readonly property int shadowPadding: Theme.marginM
  margins.top: Theme.barHeight - shadowPadding + Theme.marginM

  implicitWidth: Theme.notificationWidth + shadowPadding * 2
  implicitHeight: notificationStack.implicitHeight + Theme.marginL

  color: "transparent"
  mask: Region {
    x: 0
    y: 0
    width: notificationWindow.width
    height: notificationWindow.height
    intersection: Intersection.Xor

    Region {
      x: notificationWindow.shadowPadding
      y: notificationWindow.shadowPadding
      width: Theme.notificationWidth
      height: Math.max(0, notificationWindow.height - notificationWindow.shadowPadding * 2)
      intersection: Intersection.Subtract
    }
  }

  NotificationStack {
    id: notificationStack
    shadowPadding: notificationWindow.shadowPadding
    notifierModel: notificationWindow.notifierModel
  }
}
