import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Services
import qs.Commons

Item {
  id: root

  anchors.fill: parent

  property ShellScreen screen

  property bool _destroyed: false
  Component.onDestruction: _destroyed = true

  property ListModel leftWidgetsModel: ListModel {}
  property ListModel centerWidgetsModel: ListModel {}
  property ListModel rightWidgetsModel: ListModel {}

  onScreenChanged: {
    if (screen && screen.name) {
      Logger.d("Bar", "Bar initialized for screen:", screen.name);
      BarService.registerBar(screen.name);
    }
  }

  function filterValidWidgets(widgets: list<var>): list<var> {
    if (!widgets)
      return [];
    return widgets.filter(w => w && w.name && BarWidgetService.hasWidget(w.name));
  }

  function getSection(model) {
    return model === leftWidgetsModel ? "left" : model === centerWidgetsModel ? "center" : "right";
  }

  function syncWidgetsModel(model, widgets) {
    let validWidgets = filterValidWidgets(widgets);
    let newWidgets = validWidgets.map(w => w.name);

    let currentWidgets = [];
    for (let i = 0; i < model.count; i++) {
      currentWidgets.push(model.get(i).name);
    }

    const widgetChanged = currentWidgets.length !== newWidgets.length || currentWidgets.some((w, i) => w !== newWidgets[i]);

    Logger.d("Bar", "Syncing widgets for screen:", screen.name, "- Section:", getSection(model), "- Changed:", widgetChanged);
    Logger.d("Bar", "  - Current widgets:", currentWidgets.join("|"));
    Logger.d("Bar", "  - New widgets:", newWidgets.join("|"));

    if (widgetChanged) {
      model.clear();
      validWidgets.forEach(w => model.append(w));
    }
  }

  function syncModels() {
    if (_destroyed)
      return;
    const widgets = Settings.data.bar.widgets || [];
    if (widgets.length === 0)
      return;
    syncWidgetsModel(leftWidgetsModel, widgets.left);
    syncWidgetsModel(centerWidgetsModel, widgets.center);
    syncWidgetsModel(rightWidgetsModel, widgets.right);
  }

  Component.onCompleted: {
    Logger.d("Bar", "Bar component completed for screen:", screen?.name);
    Logger.d("Bar", "  - Bar geometry:", root.width, "x", root.height);
    Logger.d("Bar", "  - Bar position:", root.x, "x", root.y);
    Qt.callLater(syncModels);
  }

  Connections {
    target: BarService
    function onWidgetRevisionChanged() {
      Logger.d("Bar", "Bar widget revision changed:", BarService.widgetRevision, "- Syncing widgets for screen:", screen?.name);
      Qt.callLater(syncModels);
    }
  }

  Loader {
    id: barContentLoader
    anchors.fill: parent
    active: BarService.isBarReady(screen ? screen.name : null)

    sourceComponent: Item {
      anchors.fill: parent

      Item {
        id: bar

        x: 0
        y: 0
        width: parent.width
        height: parent.height

        property int sectionExtraSpace: (Theme.spacing * (Settings.data.ui.bar.height - Settings.data.ui.bar.topMarginSpacing - Settings.data.ui.bar.bottomMarginSpacing)) / 2

        Item {
          anchors.fill: parent
          clip: true

          RowLayout {
            id: leftSection
            anchors.left: parent.left
            anchors.leftMargin: Theme.spacing * Settings.data.ui.bar.leftMarginSpacing + bar.sectionExtraSpace
            y: Theme.pixelAlignCenter(parent.height, height)
            spacing: Settings.data.ui.bar.widgetSpacing * Theme.spacing
            onImplicitWidthChanged: BarService.sectionSizeChanged(root.screen.name, "left", implicitWidth)

            Repeater {
              model: root.leftWidgetsModel
              delegate: BarWidgetLoader {
                required property var model
                required property int index

                widgetName: model.name || "unknown"
                widgetScreen: root.screen
                widgetState.name: model.name || "unknown"
                widgetState.section: "left"
                widgetState.index: index
                widgetState.count: root.leftWidgetsModel.count
                Layout.alignment: Qt.AlignVCenter
              }
            }
          }
          RowLayout {
            id: centerSection
            y: Theme.pixelAlignCenter(parent.height, height)
            x: Theme.pixelAlignCenter(parent.width, width)
            spacing: Settings.data.ui.bar.widgetSpacing * Theme.spacing
            onImplicitWidthChanged: BarService.sectionSizeChanged(root.screen.name, "center", implicitWidth)

            Repeater {
              model: root.centerWidgetsModel
              delegate: BarWidgetLoader {
                required property var model
                required property int index

                widgetName: model.name || "unknown"
                widgetScreen: root.screen
                widgetState.name: model.name || "unknown"
                widgetState.section: "center"
                widgetState.index: index
                widgetState.count: root.centerWidgetsModel.count
                Layout.alignment: Qt.AlignVCenter
              }
            }
          }

          RowLayout {
            id: rightSection
            anchors.right: parent.right
            anchors.rightMargin: Theme.spacing * Settings.data.ui.bar.rightMarginSpacing + bar.sectionExtraSpace
            y: Theme.pixelAlignCenter(parent.height, height)
            spacing: Settings.data.ui.bar.widgetSpacing * Theme.spacing
            onImplicitWidthChanged: BarService.sectionSizeChanged(root.screen.name, "right", implicitWidth)

            Repeater {
              model: root.rightWidgetsModel
              delegate: BarWidgetLoader {
                required property var model
                required property int index

                widgetName: model.name || "unknown"
                widgetScreen: root.screen
                widgetState.name: model.name || "unknown"
                widgetState.section: "right"
                widgetState.index: index
                widgetState.count: root.rightWidgetsModel.count
                Layout.alignment: Qt.AlignVCenter
              }
            }
          }
        }
      }
    }
  }
}
