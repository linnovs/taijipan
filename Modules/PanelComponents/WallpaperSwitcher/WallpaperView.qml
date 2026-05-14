import QtQuick
import Quickshell
import qs.Services
import qs.Commons

PathView {
  id: root

  property ShellScreen screen
  property int preferredWidth
  property int preferredHeight
  property int selectedWallpaperIndex: -1

  property ListModel wallpaperModel
  property int baseWidth: preferredWidth / pathItemCount

  model: wallpaperModel
  pathItemCount: 7
  cacheItemCount: 5
  currentIndex: selectedWallpaperIndex
  preferredHighlightBegin: 0.5 - (1 / pathItemCount) / 2
  preferredHighlightEnd: 0.5 + (1 / pathItemCount) / 2
  highlightMoveDuration: Theme.animationFast

  function handleLeft() {
    if (!moving)
      decrementCurrentIndex();
  }

  function handleRight() {
    if (!moving)
      incrementCurrentIndex();
  }

  function handleEnter() {
    selectedWallpaperIndex = currentIndex;
    WallpaperService.changeWallpaper(currentItem.wallpaperPath);
    PanelService.closeOpenedPanel();
  }

  path: Path {
    startX: -baseWidth / 2
    startY: preferredHeight / 2
    PathAttribute {
      name: "zindex"
      value: 1
    }
    PathAttribute {
      name: "scale"
      value: 0.6
    }
    PathAttribute {
      name: "opacity"
      value: 0.7
    }

    // middle point in center
    PathLine {
      x: preferredWidth / 2
      y: preferredHeight / 2
    }
    PathAttribute {
      name: "zindex"
      value: 100
    }
    PathAttribute {
      name: "scale"
      value: 1
    }
    PathAttribute {
      name: "opacity"
      value: 1
    }

    // end point on the right
    PathLine {
      x: preferredWidth + baseWidth * 1.5
      y: preferredHeight / 2
    }
    PathAttribute {
      name: "zindex"
      value: 1
    }
    PathAttribute {
      name: "scale"
      value: 0.6
    }
    PathAttribute {
      name: "opacity"
      value: 0.7
    }
  }

  Timer {
    id: selectedTime
    interval: Theme.animationFast + Theme.timerDelay
    onTriggered: handleEnter()
  }

  delegate: WallpaperItem {
    onClicked: (x, y) => {
      const pos = mapToItem(root, x, y);
      currentIndex = root.indexAt(pos.x, pos.y);
      selectedTime.restart();
    }
  }
}
