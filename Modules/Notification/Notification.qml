import QtQuick
import qs.Services
import qs.Commons

Loader {
  id: root

  Timer {
    id: delayTimer
    interval: Theme.animationSlow + 4 * Theme.animationBuffer
    repeat: false
  }

  property bool shouldBeActive: false
  active: shouldBeActive || delayTimer.running

  property ListModel notifierModel: NotificationService.notifierModel
  Connections {
    target: notifierModel
    function onCountChanged() {
      if (notifierModel.count > 0) {
        if (!root.shouldBeActive) {
          Qt.callLater(() => shouldBeActive = true);
        }
      } else if (root.shouldBeActive) {
        root.shouldBeActive = false;
        delayTimer.restart();
      }
    }
  }

  sourceComponent: NotificationWindow {
    notifierModel: root.notifierModel
  }
}
