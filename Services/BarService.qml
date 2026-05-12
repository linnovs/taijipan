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

  function getSectionWidth(screenName, section) {
    let totalWidth = 0;
    let secWidgets = Object.values(widgets).filter(w => w.key.startsWith(`${screenName}|${section}|`)).sort((a, b) => a.index - b.index);
    if (secWidgets.length === 0)
      return 0;

    for (let i = 0; i < secWidgets.length; i++) {
      totalWidth += secWidgets[i].widget.width;
      if (i > 0 && i !== secWidgets.length - 1) {
        totalWidth += Settings.data.ui.bar.widgetSpacing * Theme.spacing;
      }
    }

    return totalWidth;
  }
}
