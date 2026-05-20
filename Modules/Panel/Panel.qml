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
      id: tooltipLoader
      active: panelWindow.panelLoaded
      asynchronous: false
      sourceComponent: TooltipWindows {
        screen: windowLoader.screen
      }

      onLoaded: {
        Logger.d("Panel", "Tooltip loaded for screen:", windowLoader.screen?.name);
      }
    }

    Loader {
      id: popupLoader
      active: panelWindow.panelLoaded
      asynchronous: false
      sourceComponent: PopupWindows {
        screen: windowLoader.screen
      }

      onLoaded: {
        Logger.d("Panel", "Popup loaded for screen:", windowLoader.screen?.name);
      }
    }

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
      id: barLoader
      active: panelWindow.panelLoaded
      asynchronous: false
      sourceComponent: BarWindows {
        screen: windowLoader.screen
      }

      onLoaded: {
        Logger.d("Panel", "BarWindow created for", windowLoader.screen?.name);
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
