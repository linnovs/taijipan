import QtQuick
import Quickshell
import qs.Commons
import qs.Services

Item {
  id: root

  required property string widgetId
  required property ShellScreen widgetScreen
  required property int widgetSection
  required property int widgetSectionIndex

  function checkWidgetExists(): bool {
    return widgetId !== "" && BarService.hasWidget(widgetId);
  }

  visible: loader.item ? true : false
  implicitWidth: loader.item && visible ? loader.item.implicitWidth : 0
  implicitHeight: loader.item && visible ? Theme.barHeight : 0
  Component.onCompleted: {
    if (!BarService.hasWidget(widgetId))
      Logger.w("BarWidgetLoader", "Widget not found:", widgetId);
  }

  Loader {
    id: loader

    anchors.fill: parent
    asynchronous: false
    active: root.checkWidgetExists()
    sourceComponent: root.checkWidgetExists() ? BarService.getWidget(root.widgetId) : null
    onLoaded: {
      if (!item)
        return;

      Logger.d("BarWidgetLoader", "Loading widget:", root.widgetId, "on screen", root.widgetScreen.name);
      if (item.hasOwnProperty("screen"))
        item.screen = root.widgetScreen;

      if (item.hasOwnProperty("onLoaded"))
        item.onLoaded();
    }
  }
}
