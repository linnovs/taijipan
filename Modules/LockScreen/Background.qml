import QtQuick
import QtQuick.Effects
import Quickshell
import qs.Services
import qs.Commons

Item {
  anchors.fill: parent

  required property ShellScreen screen

  property string wallpaperPath: ""

  Image {
    id: bgImage
    anchors.fill: parent
    visible: WallpaperService.initialized && wallpaperPath !== ""
    fillMode: Image.PreserveAspectCrop
    source: wallpaperPath
    cache: false
    smooth: true
    mipmap: false

    layer.enabled: true
    layer.smooth: false
    layer.effect: MultiEffect {
      blurEnabled: true
      blur: Settings.data.lockScreen.backgroundBlur
      blurMax: 48
    }

    Rectangle {
      anchors.fill: parent
      color: Colors.mSurface
      opacity: Settings.data.lockScreen.backgroundTint
    }
  }

  Rectangle {
    anchors.fill: parent
    gradient: Gradient {
      GradientStop {
        position: 0.0
        color: Qt.alpha(Colors.mShadow, 0.4)
      }
      GradientStop {
        position: 0.3
        color: Qt.alpha(Colors.mShadow, 0.2)
      }
      GradientStop {
        position: 0.7
        color: Qt.alpha(Colors.mShadow, 0.25)
      }
      GradientStop {
        position: 1.0
        color: Qt.alpha(Colors.mShadow, 0.5)
      }
    }
  }

  function changeWallpaper(wallpaper) {
    wallpaper = wallpaper || WallpaperService.getWallpaperForScreen(screen.name);
    ImageCacheService.getLarge(wallpaper, screen.width, screen.height, cached => {
      wallpaperPath = cached || wallpaper;
    });
  }

  Connections {
    target: WallpaperService
    function onWallpaperChanged(screenName, wallpaper) {
      if (screenName === screen.name)
        changeWallpaper(wallpaper);
    }
  }

  Component.onCompleted: {
    if (!screen)
      return;
    Qt.callLater(() => changeWallpaper());
  }
}
