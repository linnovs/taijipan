pragma Singleton
import QtQuick
import Quickshell
import qs.Modules.BarWidgets.Workspace
import qs.Modules.BarWidgets.DateTime
import qs.Modules.BarWidgets.Systray
import qs.Commons

Singleton {
  id: root

  function _widgetUrl(name) {
    return Quickshell.shellPath("Modules/BarWidgets/" + name + "/" + name + ".qml");
  }

  Component {
    id: workspaceComponent
    Workspace {}
  }

  Component {
    id: dateTimeComponent
    DateTime {}
  }

  Component {
    id: systrayComponent
    Systray {}
  }

  property var widgets: ({
      "Workspace": workspaceComponent,
      "DateTime": dateTimeComponent,
      "Systray": systrayComponent
    })

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
