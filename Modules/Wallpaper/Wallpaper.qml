import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Services
import qs.Commons

Variants {
  model: Quickshell.screens
  delegate: Loader {
    required property ShellScreen modelData
    active: modelData && Settings.data.wallpaper.enabled

    readonly property string defaultWallpaper: Quickshell.shellPath("assets/default-wallpaper.jpg")

    sourceComponent: PanelWindow {
      id: root

      property bool wallpaperReady: false

      visible: wallpaperReady

      color: "transparent"
      screen: modelData
      WlrLayershell.layer: WlrLayer.Background
      WlrLayershell.exclusiveZone: ExclusionMode.Ignore
      WlrLayershell.namespace: "taijipan-wallpaper-" + (screen?.name || "unknown")

      anchors.top: true
      anchors.right: true
      anchors.bottom: true
      anchors.left: true

      Image {
        id: currentWallpaper
        source: ""
        smooth: true
        mipmap: false
        visible: true
        cache: true
        asynchronous: true
        fillMode: Image.PreserveAspectCrop
        anchors.fill: parent
        onStatusChanged: {
          if (status === Image.Error) {
            Logger.e("Wallpaper", "Failed to load wallpaper image:", source);
          } else if (status === Image.Ready && !wallpaperReady) {
            wallpaperReady = true;
          }
        }
      }

      function setWallpaper() {
        let imgPath = Settings.data.wallpaper.selected;

        // use default wallpaper if selected file is missing or not set
        if (imgPath === "") {
          Logger.w("Wallpaper", "No wallpaper selected, using default wallpaper on", screen.name);
          imgPath = defaultWallpaper;
        } else {
          Logger.i("Wallpaper", "Setting wallpaper on", screen.name, "to", Settings.data.wallpaper.selected);
        }

        ImageCacheService.openBG(imgPath, width, height, function (imageSource) {
          currentWallpaper.source = imageSource;
        });
      }

      Connections {
        target: Settings.data.wallpaper
        function onSelectedChanged() {
          setWallpaper();
        }
      }

      function initializeWallpaper() {
        if (!ImageCacheService.initialized) {
          Qt.callLater(initializeWallpaper);
          return;
        }

        setWallpaper();
      }

      Component.onCompleted: initializeWallpaper()
    }
  }
}
