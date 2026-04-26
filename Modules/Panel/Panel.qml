import QtQuick
import Quickshell
import qs.Commons

Variants {
  model: Quickshell.screens
  delegate: Item {
    id: panelWindow
    required property ShellScreen modelData

    property bool panelLoaded: false

    Loader {
      id: windowLoader
      asynchronous: false

      property ShellScreen screen: modelData

      onLoaded: panelWindow.panelLoaded = true
      sourceComponent: PanelWindows {
        screen: windowLoader.screen
      }
    }

    Loader {
      id: barExclusionLoader
      active: panelWindow.panelLoaded
      asynchronous: false
      sourceComponent: BarExclusionZone {
        screen: windowLoader.screen
      }

      onLoaded: {
        Logger.d("Panel", "Bar exclusion zone loaded for screen:", windowLoader.screen?.name);
      }
    }
  }
}
