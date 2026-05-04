import QtQuick
import QtQuick.Controls
import qs.Services
import qs.Widgets
import qs.Commons

BasePanel {
  id: root

  exclusiveKeyboardFocus: true

  panelPosition.placeInCenter: true
  panelSize.preferredWidth: screen ? screen.width : 400
  panelSize.preferredHeight: ImageCacheService.thumbnailSize

  property ListModel wallpaperModel: ListModel {}
  property bool loading: true
  property var panelContentItem: null

  panelComponent: Item {
    id: panelContent

    Loader {
      id: wallpaperViewLoader
      active: !WallpaperService.isScanning || !loading
      sourceComponent: WallpaperView {
        screen: root.screen
        wallpaperModel: root.wallpaperModel
        preferredHeight: panelSize.preferredHeight
      }
    }

    property alias wallpaperView: wallpaperViewLoader.item

    BusyIndicator {
      running: WallpaperService.isScanning || loading
      anchors.centerIn: parent
    }

    Component.onCompleted: {
      root.panelContentItem = panelContent;
    }
  }

  function onLeftPressed() {
    panelContentItem.wallpaperView.handleLeft();
  }

  function onRightPressed() {
    panelContentItem.wallpaperView.handleRight();
  }

  function onEnterPressed() {
    panelContentItem.wallpaperView.handleEnter();
  }

  Connections {
    target: WallpaperService
    function onScanFinished() {
      let count = WallpaperService.wallpaperList.length;
      WallpaperService.wallpaperList.forEach(function (wallpaperPath) {
        Logger.d("WallpaperSwitcher", "Found wallpaper:", wallpaperPath);
        ImageCacheService.getThumbnail(wallpaperPath, function (cached) {
          wallpaperModel.append({
            wallpaperPath: wallpaperPath,
            cachedPath: cached !== "" ? cached : wallpaperPath
          });

          count--;
          loading = count > 0;
        });
      });
    }
  }

  Component.onCompleted: {
    WallpaperService.refreshWallpapers();
  }
}
