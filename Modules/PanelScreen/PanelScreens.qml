pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.Commons

Variants {
  id: root
  model: Quickshell.screens
  delegate: Item {
    id: screenItem
    required property ShellScreen modelData
    property bool shouldBeActive: {
      if (!modelData || !modelData.name) {
        return false;
      }

      Logger.d("PanelScreens", "Screen activated:", modelData.name);

      return true;
    }
    property bool windowLoaded: false

    Loader {
      id: windowLoader
      active: parent.shouldBeActive
      asynchronous: false

      property ShellScreen loaderScreen: screenItem.modelData

      onLoaded: {
        parent.windowLoaded = true;
      }

      sourceComponent: MainWindow {
        screen: windowLoader.loaderScreen
      }
    }

    Loader {
      active: screenItem.windowLoaded && screenItem.shouldBeActive
      asynchronous: false
      onLoaded: {
        Logger.d("PanelScreens", "BarWindow created for", screenItem.modelData?.name);
      }
      sourceComponent: BarWindow {
        screen: screenItem.modelData
      }
    }

    Loader {
      active: screenItem.windowLoaded && screenItem.shouldBeActive
      asynchronous: false
      onLoaded: {
        Logger.d("PanelScreens", "BarExclusionZone created for", screenItem.modelData?.name);
      }

      sourceComponent: BarExclusionZone {
        screen: screenItem.modelData
      }
    }
  }
}
