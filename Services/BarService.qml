pragma Singleton

import QtQuick
import Quickshell
import qs.Modules.Bar.Widgets
import qs.Commons

Singleton {
  id: root

  Component {
    id: datetimeComp
    DateTime {}
  }

  property var bars: ({})
  property int revision: 0

  readonly property var widgets: ({
    "DateTime": datetimeComp
  })

  function filterWidgets(widgetList: list<var>): list<var> {
    if (!widgetList) return []
    return widgetList.filter(w => w && w.id && w.id in widgets);
  }

  function hasWidget(id) {
    return id in widgets;
  }

  function getWidget(id) {
    return widgets[id] || null;
  }

  Component.onCompleted: {
    Logger.i("BarService", "BarService started");
  }

  function registerBar(screenName) {
    if (!bars[screenName]) {
      bars[screenName] = true;
      Logger.d("BarService", "Bar is ready on screen:", screenName);
    }
  }

  Connections {
    target: Settings
    function onSettingsReloaded() {
      Logger.d("BarService", "Settings reloaded, updating bars...");
      root.revision++;
    }
  }
}
