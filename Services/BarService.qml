pragma Singleton
import QtQuick
import Quickshell
import qs.Commons

Singleton {
  id: root

  property int widgetRevision: 0

  Connections {
    target: Settings
    function onSettingsReloaded() {
      Logger.d("BarService", "Settings reloaded, incrementing widget revision");
      widgetRevision++;
    }
  }

  // key: screenName|section|index|widgetName
  // content: { key, screenName, section, index, widgetName, widget }
  property var widgets: ({})

  // key: screenName
  property var readyBars: ({})

  function registerBar(screenName) {
    if (!readyBars[screenName]) {
      readyBars[screenName] = true;
      readyBars = Object.assign({}, readyBars); // Trigger reactivity
      Logger.d("BarService", "Registered bar for screen:", screenName);
    }
  }

  function isBarReady(screenName) {
    return readyBars[screenName] || false;
  }

  // sectionSizeChanged emitted when a widget's size changes and the bar needs to update the section's total width
  signal sectionSizeChanged(string screenName, string section, real width)

  function registerWidget(screenName, section, index, widgetName, widget) {
    const key = `${screenName}|${section}|${index}|${widgetName}`;
    widgets[key] = {
      key,
      screenName,
      section,
      index,
      widgetName,
      widget
    };
    widgets = Object.assign({}, widgets); // Trigger reactivity
    Logger.d("BarService", "Registered widget:", key);
  }

  function unregisterWidget(screenName, section, index, widgetName, widget) {
    const key = `${screenName}|${section}|${index}|${widgetName}`;
    delete widgets[key];
    widgets = Object.assign({}, widgets); // Trigger reactivity
    Logger.d("BarService", "Unregistered widget:", key);
  }
}
