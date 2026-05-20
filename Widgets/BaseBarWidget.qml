import QtQuick
import Quickshell
import qs.Commons

Item {
  id: root

  required property ShellScreen screen
  required property string name
  required property string section
  required property int index
  required property int count

  property Component widgetSource

  component WidgetSize: QtObject {
    property int x
    property int y
    property int width
    property int height
  }
  property WidgetSize widgetRawSize: WidgetSize {
    x: 0
    y: -Theme.frameThickness
    width: root.implicitWidth
    height: Theme.barHeight + Theme.frameThickness
  }

  Loader {
    id: widgetLoader
    active: widgetSource !== null || widgetSource !== undefined
    anchors.centerIn: parent
    sourceComponent: widgetSource
  }

  implicitWidth: widgetLoader.item.implicitWidth ?? 0
  implicitHeight: Theme.barHeight - Theme.frameThickness

  Component.onCompleted: {
    Logger.d("BarWidget", `Widget(${name}) initialized on screen:`, screen.name, "- section:", section, "- index:", index, "- count:", count);
  }
}
