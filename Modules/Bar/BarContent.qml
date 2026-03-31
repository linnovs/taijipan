pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons

Item {
  id: root
  anchors.fill: parent

  required property ShellScreen screen
  required property ListModel leftWidgetsModel
  required property ListModel centerWidgetsModel
  required property ListModel rightWidgetsModel

  Item {
    anchors.fill: parent
    clip: true

    readonly property real barMargin: Math.round((Theme.barHeight - Theme.barCapsuleHeight) / 2)

    RowLayout {
      id: centerSection
      objectName: "centerSection"
      anchors.horizontalCenter: parent.horizontalCenter
      y: Math.round((parent.height - height) / 2)
      spacing: Settings.data.bar.widgetSpacing

      Repeater {
        model: root.centerWidgetsModel
        delegate: BarWidgetLoader {
          required property var model
          required property var index

          widgetId: model.id || ""
          widgetScreen: root.screen
          widgetSection: Bar.Section.Center
          widgetSectionIndex: index

          Layout.alignment: Qt.AlignVCenter
        }
      }
    }
  }
}
