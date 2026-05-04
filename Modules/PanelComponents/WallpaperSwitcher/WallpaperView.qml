import QtQuick
import Quickshell
import qs.Services
import qs.Commons

PathView {
  id: root

  property ShellScreen screen
  property real preferredHeight

  property ListModel wallpaperModel
  property real baseWidth: screen.width / pathItemCount

  model: wallpaperModel
  pathItemCount: 7
  cacheItemCount: 5
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
    WallpaperService.changeWallpaper(currentItem.wallpaperPath);
    PanelService.closePanel();
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
      x: screen.width / 2
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
      x: screen.width + baseWidth * 1.5
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
    interval: Theme.animationFast + Theme.animationBuffer
    onTriggered: handleEnter()
  }

  delegate: WallpaperItem {
    onSelected: (x, y) => {
      const pos = mapToItem(root, x, y);
      currentIndex = root.indexAt(pos.x, pos.y);
      selectedTime.restart();
    }
  }
}
