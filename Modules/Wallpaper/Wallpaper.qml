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

      color: "transparent"
      screen: modelData
      WlrLayershell.layer: WlrLayer.Background
      WlrLayershell.exclusiveZone: ExclusionMode.Ignore
      WlrLayershell.namespace: "taijipan-wallpaper-" + (screen?.name || "unknown")

      anchors.top: true
      anchors.right: true
      anchors.bottom: true
      anchors.left: true

      property bool wallpaperReady: false
      property bool initialized: false

      visible: wallpaperReady

      property real transitionProgress: 0

      NumberAnimation {
        id: transitionAnimation
        target: root
        property: "transitionProgress"
        from: 0.0
        to: 1.0
        duration: Theme.animationSlowest
        onFinished: {
          if (!initialized) {
            initialized = true;
          }

          const wallpaperSource = nextWallpaper.source;
          currentWallpaper.source = wallpaperSource;
          transitionProgress = 0.0;

          Qt.callLater(() => {
            currentWallpaper.asynchronous = true;
            nextWallpaper.source = "";
          });
        }
      }

      property bool isTransitioning: transitionAnimation.running

      Image {
        id: currentWallpaper
        source: ""
        visible: false
        asynchronous: true
        onStatusChanged: {
          if (status === Image.Error) {
            Logger.e("Wallpaper", "Failed to load current wallpaper image:", source);
          }
        }
      }

      Image {
        id: nextWallpaper
        source: ""
        visible: false
        cache: false
        asynchronous: true
        onStatusChanged: {
          if (status === Image.Error) {
            Logger.e("Wallpaper", "Failed to load next wallpaper image:", source);
          } else if (status === Image.Ready) {
            if (!wallpaperReady) {
              wallpaperReady = true;
            }
            transitionAnimation.start();
          }
        }
      }

      ShaderEffect {
        anchors.fill: parent

        property variant sourceImg: currentWallpaper
        property variant destImg: nextWallpaper

        property real progress: transitionProgress
        property real maxRadius: 1.0

        property real origImgWidth: sourceImg.sourceSize.width
        property real origImgHeight: sourceImg.sourceSize.height
        property real destImgWidth: destImg.sourceSize.width
        property real destImgHeight: destImg.sourceSize.height

        property real screenWidth: screen.width
        property real screenHeight: screen.height
        property vector2d aspectRatio: Qt.vector2d(1, screen.width / screen.height)

        property real origIsSolid: initialized ? 0.0 : 1.0
        property vector4d solid: Qt.vector4d(Colors.mBackground.r, Colors.mBackground.g, Colors.mBackground.b, 1)

        fragmentShader: Quickshell.shellPath("assets/shaders/qsb/wallpaper_transition.frag.qsb")
      }

      function updateNextWallpaper() {
        const bg = Settings.data.wallpaper.selected || defaultWallpaper;
        ImageCacheService.openBG(bg, screen.width, screen.height, function (imageSource) {
          currentWallpaper.asynchronous = false;
          nextWallpaper.source = imageSource;
        });
      }

      function changeWallpaper() {
        if (isTransitioning) {
          transitionAnimation.stop();
          transitionProgress = 0.0;

          // clean up the current wallpaper and move the next wallpaper to the current wallpaper
          Qt.callLater(() => {
            const newCurrentSource = nextWallpaper.source;
            currentWallpaper.source = newCurrentSource;

            // start next transition after a small delay
            Qt.callLater(() => {
              updateNextWallpaper();
            });
          });
          return;
        }

        updateNextWallpaper();
      }

      Connections {
        target: Settings.data.wallpaper
        function onSelectedChanged() {
          changeWallpaper();
        }
      }

      function initializeWallpaper() {
        if (!ImageCacheService.initialized) {
          Qt.callLater(initializeWallpaper);
          return;
        }

        changeWallpaper();
      }

      Component.onCompleted: initializeWallpaper()
    }
  }
}
