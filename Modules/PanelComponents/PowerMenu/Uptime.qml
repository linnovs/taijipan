import QtQuick
import QtQuick.Layouts
import qs.Services
import qs.Commons

Item {
  id: root

  Layout.fillWidth: true
  Layout.preferredHeight: Theme.fontSizeMD + Theme.marginXS * 2

  Text {
    id: uptimeText
    anchors.centerIn: parent
    text: currentUptime
    color: Colors.mOnSurface
    font.pointSize: Theme.fontSizeMD
    font.weight: Font.DemiBold
  }

  Connections {
    target: UptimeService
    function onUptimeChanged(uptime) {
      uptimeText.text = uptime;
    }
  }

  Component.onCompleted: {
    UptimeService.registerComponent("PowerMenuUptime");
  }

  Component.onDestruction: {
    UptimeService.unregisterComponent("PowerMenuUptime");
  }
}
