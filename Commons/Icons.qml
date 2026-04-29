pragma Singleton
import QtQuick
import Quickshell

Singleton {
  id: root

  readonly property var icons: IconsMaterialSymbols.icons
  readonly property string fontPath: "/assets/fonts/Material Symbols/MaterialSymbolsRounded-VariableFont_FILL,GRAD,opsz,wght.ttf"

  property FontLoader currentFontLoader: null
  property int fontVersion: 0

  readonly property string fontFamily: currentFontLoader ? currentFontLoader.name : null
  readonly property string defaultIcon: IconsMaterialSymbols.defaultIcon

  // unique cache key to force reload when font changes
  readonly property string cacheBustingPath: Quickshell.shellPath(fontPath + "?v=" + fontVersion + "&t=" + Date.now())

  Component {
    id: fontLoaderComponent
    FontLoader {
      property string fontSource
      source: fontSource
    }
  }

  function loadFontWithCacheBusting() {
    Logger.d("Icons", "Loading font with cache busting");

    if (currentFontLoader) {
      currentFontLoader.destroy();
      currentFontLoader = null;
    }

    currentFontLoader = fontLoaderComponent.createObject(root, {
      fontSource: root.cacheBustingPath
    });
    currentFontLoader.statusChanged.connect(function () {
      if (currentFontLoader.status === FontLoader.Ready) {
        Logger.d("Icons", "Font loaded successfully:", root.fontFamily, "(version", fontVersion, ")");
      } else if (currentFontLoader.status === FontLoader.Error) {
        Logger.e("Icons", "Failed to load font:", root.cacheBustingPath);
      }
    });
  }

  function reloadFont() {
    fontVersion++;
    Logger.d("Icons", "Reloading font, current version:", root.fontVersion);
    loadFontWithCacheBusting();
  }

  Component.onCompleted: {
    Logger.i("Icons", "Loading icons font from:", root.fontPath);
    loadFontWithCacheBusting();
  }

  Connections {
    target: Quickshell
    function onReloadCompleted() {
      Logger.d("Icons", "Quickshell reload completed, reloading icons font");
      reloadFont();
    }
  }

  function get(name) {
    return icons[name];
  }
}
