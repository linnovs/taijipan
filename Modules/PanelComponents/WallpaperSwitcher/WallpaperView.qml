import QtQuick
import qs.Services
import qs.Commons

PathView {
  id: root
  clip: true

  property int selectedWallpaperIndex: -1

  property ListModel wallpaperModel
  property int baseWidth: width / pathItemCount

  model: wallpaperModel
  pathItemCount: 7
  cacheItemCount: 5
  currentIndex: selectedWallpaperIndex
  preferredHighlightBegin: 0.5
  preferredHighlightEnd: 0.5
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
    startX: 0
    startY: root.height / 2
    PathAttribute {
      name: "zindex"
      value: 50
    }
    PathAttribute {
      name: "scale"
      value: 0.1
    }
    PathAttribute {
      name: "opacity"
      value: 0.7
    }

    PathLine {
      x: root.width / 2
      y: root.height / 2
    }
    PathAttribute {
      name: "zindex"
      value: 100
    }
    PathAttribute {
      name: "scale"
      value: 1.0
    }
    PathAttribute {
      name: "opacity"
      value: 1.0
    }

    PathLine {
      x: root.width
      y: root.height / 2
    }
    PathAttribute {
      name: "zindex"
      value: 50
    }
    PathAttribute {
      name: "scale"
      value: 0.1
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
