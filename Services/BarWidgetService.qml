pragma Singleton
import QtQuick
import Quickshell
import qs.Commons

Singleton {
  id: root

  function _widgetUrl(name) {
    return Quickshell.shellPath("Modules/BarWidgets/" + name + "/" + name + ".qml");
  }

  property var widgets: ({})

  function hasWidget(name) {
    return name in widgets;
  }

  function getWidgetUrl(name) {
    if (!hasWidget(name)) {
      return null;
    }
    return _widgetUrl(name);
  }

  Component.onCompleted: {
    Logger.i("BarWidgetService", "Initialize with widgets:", Object.keys(widgets).join(","));
  }
}
