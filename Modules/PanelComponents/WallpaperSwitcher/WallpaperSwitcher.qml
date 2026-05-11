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
  panelSize.topMargin: Theme.marginMD
  panelSize.leftMargin: Theme.marginMD
  panelSize.rightMargin: Theme.marginMD
  panelSize.bottomMargin: Theme.marginMD

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
      context: Qt.ApplicationShortcut
      onActivated: {
        loading = true;
        wallpaperModel.clear();
        WallpaperService.refreshWallpapers();
        Logger.d("WallpaperSwitcher", "Refresh triggered by user");
      }
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
    id: afterRefreshTimer
    interval: Theme.timerDelay
    onTriggered: loading = false
  }

  Timer {
    id: refreshTimer
    interval: Theme.timerDelay
    onTriggered: {
      const currentWallpaper = WallpaperService.getWallpaperForScreen(root.screen.name);
      for (let i = 0; i < wallpaperModel.count; i++) {
        if (wallpaperModel.get(i).wallpaperPath === currentWallpaper) {
          selectedWallpaperIndex = i;
          afterRefreshTimer.restart();
          return;
        }
      }
    }
  }

  Connections {
    target: WallpaperService
    function onScanFinished() {
      let count = WallpaperService.wallpaperList.length;
      WallpaperService.wallpaperList.forEach(function (wallpaperPath) {
        ImageCacheService.getThumbnail(wallpaperPath, function (cached) {
          wallpaperModel.append({
            wallpaperPath: wallpaperPath,
            cachedPath: cached !== "" ? cached : wallpaperPath
          });

          count--;
          if (count === 0) {
            refreshTimer.restart();
          }
        });
      });
    }
  }

  Component.onCompleted: {
    WallpaperService.refreshWallpapers();
  }
}
