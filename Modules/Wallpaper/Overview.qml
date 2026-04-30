import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import qs.Services
import qs.Commons

Loader {
  active: Settings.data.wallpaper.enabled
  sourceComponent: Variants {
    model: Quickshell.screens
    delegate: PanelWindow {
      id: root
      required property ShellScreen modelData
      property string wallpaper: ""
      property string processedWallpaper: ""

      color: "transparent"
      screen: modelData
      WlrLayershell.layer: WlrLayer.Background
      WlrLayershell.exclusionMode: ExclusionMode.Ignore
      WlrLayershell.namespace: "taijipan-overview-" + (screen?.name || "unknown")

      anchors.top: true
      anchors.right: true
      anchors.bottom: true
      anchors.left: true

      Connections {
        target: WallpaperService
        function onPostWallpaperProcess(screen, wallpaper, cached) {
          if (screen === modelData.name) {
            root.processedWallpaper = cached || "";
            root.wallpaper = wallpaper;
          }
        }
      }

      Component.onCompleted: {
        Logger.d("Overview", "Loading overview backdrop for", screen.name);
      }

      Rectangle {
        id: solidColorBg
        visible: !WallpaperService.initialized
        color: Colors.mBackground

        Rectangle {
          anchors.fill: parent
          color: Colors.mSurface
          opacity: Settings.data.wallpaper.overviewTint
        }
      }

      Image {
        id: bgImg
        anchors.fill: parent
        visible: WallpaperService.initialized
        fillMode: Image.PreserveAspectCrop
        source: processedWallpaper || wallpaper
        asynchronous: true

        layer.enabled: Settings.data.wallpaper.overviewBlur > 0
        layer.smooth: false
        layer.effect: MultiEffect {
          blurEnabled: true
          blur: Settings.data.wallpaper.overviewBlur
          blurMax: 48
        }

        Rectangle {
          anchors.fill: parent
          color: Colors.mSurface
          opacity: Settings.data.wallpaper.overviewTint
        }
      }
    }
  }
}
