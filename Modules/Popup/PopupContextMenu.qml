import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.Widgets
import qs.Commons

PopupWindow {
  id: root

  property var anchorItem: null
  property ShellScreen attachedScreen: null
  readonly property int frameThickness: Theme.spacing * Settings.data.ui.frameThickness

  color: "transparent"

  signal popupOpened
  signal popupClosed

  anchor.item: anchorItem
  anchor.rect.x: {
    if (!anchorItem && !attachedScreen)
      return 0;

    if (anchorItem.x + implicitWidth > attachedScreen.width - frameThickness - Theme.marginXXS)
      return (attachedScreen.width - implicitWidth - frameThickness) - anchorItem.x - Theme.marginXXS;

    if (anchorItem.x < frameThickness)
      return frameThickness + Theme.marginXXS;

    return Theme.marginXXS;
  }
  anchor.rect.y: Theme.marginXXS
  visible: false

  BackgroundEffect.blurRegion: Region {
    width: implicitWidth
    height: implicitHeight
    radius: Theme.radiusMD
  }

  signal triggered(string action, var item)

  Text {
    id: textMetrics
    font.family: Settings.data.ui.font
    font.pixelSize: Theme.fontSizeMD
    visible: false
    wrapMode: Text.NoWrap
    elide: Text.ElideNone
    width: undefined
  }

  TextIcon {
    id: iconMetrics
    icon: "notifications"
    iconSize: Theme.iconSizeXS
    visible: false
  }

  Rectangle {
    id: background
    anchors.fill: parent
    color: Qt.alpha(Colors.mSurface, Settings.data.ui.popup.contextMenu.opacity)
    radius: Theme.radiusMD
    opacity: root.visible ? 1 : 0

    Behavior on opacity {
      NumberAnimation {
        duration: Theme.animationNormal
        easing.type: Easing.OutQuad
      }
    }
  }

  ColumnLayout {
    id: item
    anchors.fill: parent
    anchors.margins: Theme.marginXXS
    spacing: 0

    Repeater {
      id: itemRepeater
      delegate: ContextMenuItem {
        onTriggered: (action, menuItem) => root.triggered(action, menuItem)
      }
    }
  }

  readonly property int defaultWidth: Theme.widthXS - Theme.marginLG
  property int calculatedWidth: defaultWidth

  implicitWidth: calculatedWidth
  implicitHeight: item.implicitHeight + Theme.marginXXS * 2

  property alias model: itemRepeater.model

  function calculateWidth() {
    const padding = Theme.marginXXS * 2;

    let maxWidth = 0;
    for (let i = 0; i < model.count; i++) {
      const item = model.get(i);

      if (item.isSeparator)
        continue;

      textMetrics.text = item.label || "";
      textMetrics.forceLayout();

      let itemWidth = textMetrics.width + Theme.marginXS * 2;
      itemWidth += iconMetrics.iconSize + Theme.spacing;

      if (itemWidth > maxWidth)
        maxWidth = itemWidth;
    }

    calculatedWidth = Math.max(defaultWidth, maxWidth + padding);
  }

  function close() {
    visible = false;
    popupClosed();
  }

  function open() {
    Qt.callLater(() => {
      calculateWidth();
      visible = true;
      popupOpened();
    });
  }
}
