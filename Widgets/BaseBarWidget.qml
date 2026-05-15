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
  property int frameThickness: Theme.spacing * Settings.data.ui.frameThickness
  property int barHeight: Theme.spacing * Settings.data.ui.bar.height

  component WidgetSize: QtObject {
    property int x
    property int y
    property int width
    property int height
  }
  property WidgetSize widgetRawSize: WidgetSize {
    x: 0
    y: -root.frameThickness
    width: root.implicitWidth
    height: root.barHeight + root.frameThickness
  }

  Loader {
    id: widgetLoader
    active: widgetSource !== null || widgetSource !== undefined
    anchors.centerIn: parent
    sourceComponent: widgetSource
  }

  implicitWidth: widgetLoader.item.implicitWidth ?? 0
  implicitHeight: root.barHeight - root.frameThickness

  Component.onCompleted: {
    Logger.d("BarWidget", `Widget(${name}) initialized on screen:`, screen.name, "- section:", section, "- index:", index, "- count:", count);
  }
}
