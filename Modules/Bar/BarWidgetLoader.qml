import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Services
import qs.Commons

Item {
  id: root

  property string widgetName
  property ShellScreen widgetScreen

  property Loader widgetLoader

  component WidgetState: QtObject {
    property string name
    property string section
    property int index
    property int count
  }
  property WidgetState widgetState: WidgetState {}

  component RegisterState: QtObject {
    property string screenName
    property string name
    property string section
    property int index
    property var item
  }
  property RegisterState registerState: RegisterState {}

  function loadWidget() {
    if (!BarWidgetService.hasWidget(widgetName))
      return;
    Logger.d("BarWidgetLoader", "Loading widget:", widgetName, "for screen:", widgetScreen?.name);
    widgetLoader.setSource(BarWidgetService.getWidgetUrl(widgetName), {
      screen: widgetScreen,
      name: widgetState.name,
      section: widgetState.section,
      index: widgetState.index,
      count: widgetState.count
    });
  }

  function registerWidget(widget) {
    registerState.screenName = widgetScreen.name;
    registerState.name = widgetState.name;
    registerState.section = widgetState.section;
    registerState.index = widgetState.index;
    registerState.item = widget;
    BarService.registerWidget(registerState.screenName, registerState.section, registerState.index, registerState.name, registerState.item);
  }

  function unregisterWidget() {
    if (registerState.screenName === "")
      return;
    BarService.unregisterWidget(registerState.screenName, registerState.section, registerState.index, registerState.name, registerState.item);
    registerState.screenName = "";
  }

  Loader {
    id: loader
    anchors.fill: parent
    asynchronous: true
    active: BarWidgetService.hasWidget(widgetName)

    Component.onCompleted: loadWidget()
    onActiveChanged: {
      if (active)
        loadWidget();
    }

    onLoaded: {
      if (!item)
        return;

      unregisterWidget();
      registerWidget(item);
    }

    Component.onDestruction: root.unregisterWidget()
  }

  Layout.preferredWidth: (loader.item && loader.item.visible) ? loader.item.implicitWidth : 0
  Layout.preferredHeight: (loader.item && loader.item.visible) ? parent.height : 0

  Component.onCompleted: {
    if (!BarWidgetService.hasWidget(widgetName)) {
      Logger.w("BarWidgetLoader", "Widget not found:", widgetName);
      return;
    }
    widgetLoader = loader;
  }
}
