import QtQuick
import Quickshell.Services.SystemTray
import qs.Widgets
import qs.Services
import qs.Commons

BaseBarWidget {
  id: root

  property var systrayItems: SystemTray.items && SystemTray.items.values ? SystemTray.items.values : []

  property int systrayIconSize: root.height * 0.7

  widgetSource: Row {
    spacing: Theme.spacing

    Repeater {
      model: root.systrayItems
      delegate: Item {
        id: item
        height: root.height
        width: root.systrayIconSize

        Image {
          id: icon
          anchors.centerIn: parent
          source: model.icon
          sourceSize: Qt.size(systrayIconSize, systrayIconSize)
        }

        MouseArea {
          id: mouseArea
          anchors.fill: parent
          hoverEnabled: true
          acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
          onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
              modelData.activate();
            }
          }
          onEntered: {
            const atPoint = root.mapToGlobal(item.x + item.width / 2, root.height);
            TooltipService.show(`systray-${model.id}`, model.tooltipTitle || model.title, model.tooltipDescription, root.screen.name, atPoint.x, atPoint.y);
          }
          onExited: {
            TooltipService.hide(`systray-${model.id}`, root.screen.name);
          }
        }
      }
    }
  }
}
