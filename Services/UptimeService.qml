pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons

Singleton {
  id: root

  property var _registered: ({})
  readonly property int _count: Object.keys(_registered).length
  readonly property bool shouldRun: _count > 0

  property string currentUptime: ""

  signal uptimeChanged(string uptime)

  function registerComponent(componentId) {
    root._registered[componentId] = true;
    root._registered = Object.assign({}, root._registered);
    Logger.d("UptimeService", "Registered component:", componentId, "Total count:", root._count);
  }

  function unregisterComponent(componentId) {
    delete root._registered[componentId];
    root._registered = Object.assign({}, root._registered);
    Logger.d("UptimeService", "Unregistered component:", componentId, "Total count:", root._count);
  }

  onCurrentUptimeChanged: root.uptimeChanged(root.currentUptime)

  Process {
    id: uptimeProcess
    command: ["uptime", "-p"]
    stdout: StdioCollector {
      onStreamFinished: root.currentUptime = text.trim().replace("up ", "")
    }
  }

  Timer {
    interval: 60 * 1000
    repeat: true
    running: root.shouldRun
    triggeredOnStart: true
    onTriggered: uptimeProcess.running = true
  }
}
