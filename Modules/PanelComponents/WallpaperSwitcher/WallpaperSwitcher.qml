import QtQuick
import QtQuick.Controls
import qs.Services
import qs.Widgets
import qs.Commons

BasePanel {
  id: root

  exclusiveKeyboardFocus: true

  panelPosition.placement: BasePanel.Placement.Bottom
  panelPosition.margins.bottom: screen.height * 0.05
  panelSize.preferredWidth: screen ? screen.width : 400
  panelSize.preferredHeight: ImageCacheService.thumbnailSize

  property ListModel wallpaperModel: ListModel {}
  property bool loading: true
  property var panelContentItem: null
  property int selectedWallpaperIndex: -1

  panelComponent: Item {
    id: panelContent

    Loader {
      id: wallpaperViewLoader
      active: !WallpaperService.isScanning && !loading
      sourceComponent: WallpaperView {
        screen: root.screen
        wallpaperModel: root.wallpaperModel
        preferredHeight: panelSize.preferredHeight
        currentIndex: selectedWallpaperIndex
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

    Shortcut {
      sequence: "R"
      onActivated: WallpaperService.refreshWallpapers()
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

  Timer {
    id: loadingDelayTimer
    interval: Theme.animationBuffer
    onTriggered: {
      for (let i = 0; i < wallpaperModel.count; i++) {
        if (wallpaperModel.get(i).index === WallpaperService.getWallpaperIndex(root.screen.name)) {
          selectedWallpaperIndex = i;
          break;
        }
      }
      loading = false;
    }
  }

  Connections {
    target: WallpaperService
    function onScanFinished() {
      wallpaperModel.clear();
      loading = true;

      let count = WallpaperService.wallpaperList.length;
      WallpaperService.wallpaperList.forEach(function (wallpaperPath, index) {
        Logger.d("WallpaperSwitcher", "Found wallpaper:", Paths.replaceHomeWithTilde(wallpaperPath));
        ImageCacheService.getThumbnail(wallpaperPath, function (cached) {
          wallpaperModel.append({
            wallpaperPath: wallpaperPath,
            cachedPath: cached !== "" ? cached : wallpaperPath,
            index: index
          });

          count--;
          if (count === 0) {
            loadingDelayTimer.restart();
          }
        });
      });
    }
  }

  Component.onCompleted: {
    WallpaperService.refreshWallpapers();
  }
}
