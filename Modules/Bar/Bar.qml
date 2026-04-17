pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.Services
import qs.Commons

Item {
  id: root

  enum Section {
    Left,
    Center,
    Right
  }

  required property ShellScreen screen

  property ListModel leftWidgetsModel: ListModel {}
  property ListModel centerWidgetsModel: ListModel {}
  property ListModel rightWidgetsModel: ListModel {}

  function syncWidgetModel(model, widgets) {
    var validWidgets = BarService.filterWidgets(widgets);

    var currentIds = [];
    for (var i = 0; i < model.count; i++) {
      currentIds.push(model.get(i).id);
    }

    var newIds = validWidgets.map(w => w.id);

    var changed = currentIds.length !== newIds.length;
    if (!changed) {
      for (var i = 0; i < currentIds.length; i++) {
        if (currentIds[i] !== newIds[i]) {
          changed = true;
          break;
        }
      }
    }

    if (changed) {
      model.clear();
      for (var i = 0; i < validWidgets.length; i++) {
        model.append(validWidgets[i]);
      }
    }

    Logger.d("Bar", "Syncing widget model: ", currentIds.join("|"), "", newIds.join("|"));
  }

  function syncAllWidgetModels() {
    var widgets = Settings.data.bar.widgets;
    if (widgets) {
      syncWidgetModel(root.leftWidgetsModel, widgets.left);
      syncWidgetModel(root.centerWidgetsModel, widgets.center);
      syncWidgetModel(root.rightWidgetsModel, widgets.right);
    }
  }

  Connections {
    target: BarService
    function onRevisionChanged() {
      Logger.d("Bar", "revision changed, revision:", BarService.revision, " syncing widget models...");
      root.syncAllWidgetModels();
    }
  }

  Component.onCompleted: {
    Logger.d("Bar", "Bar component created for screen:", screen?.name);
    root.syncAllWidgetModels();
  }

  onScreenChanged: {
    if (screen && screen.name) {
      Logger.d("Bar", "Bar screen changed, new screen:", screen.name, " registering bar...");
      BarService.registerBar(screen.name);
    }
  }

  Loader {
    id: barContentLoader
    anchors.fill: parent
    active: root.screen !== null
    sourceComponent: BarContent {
      screen: root.screen
      leftWidgetsModel: root.leftWidgetsModel
      centerWidgetsModel: root.centerWidgetsModel
      rightWidgetsModel: root.rightWidgetsModel
    }
  }
}
