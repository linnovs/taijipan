import QtQuick
import qs.Services
import qs.Commons

Item {
  id: root

  Text {
    id: uptimeText
    font.family: Settings.data.ui.font
    font.pixelSize: Theme.fontSizeLG
    color: Qt.alpha(Colors.mOnSurface, 0.8)
  }

  implicitWidth: uptimeText.width
  implicitHeight: uptimeText.height

  Connections {
    target: UptimeService
    function onUptimeChanged(uptime) {
      uptimeText.text = uptime;
    }
  }

  Component.onCompleted: {
    UptimeService.registerComponent("LockScreenUptime");
    Qt.callLater(() => {
      uptimeText.text = UptimeService.currentUptime;
    });
  }

  Component.onDestruction: {
    UptimeService.unregisterComponent("LockScreenUptime");
  }
}
