import QtQuick
import qs.Services
import qs.Commons

Rectangle {
  id: root
  required property var model
  property var screen
  property var widgetRoot

  property int activeWidth
  property int inactiveWidth
  property int pillHeight

  implicitWidth: model.isActive ? activeWidth : inactiveWidth
  implicitHeight: pillHeight
  radius: Theme.radiusRound

  HoverHandler {
    id: hover
    margin: Theme.marginXS
    onHoveredChanged: {
      if (hover.hovered) {
        const atPoint = widgetRoot.mapToGlobal(root.x + root.width / 2, widgetRoot.height);
        TooltipService.show(`ws-${model.id}`, model.name || `Workspace ${model.idx}`, "", root.screen.name, atPoint.x, atPoint.y);
      } else {
        TooltipService.hide(`ws-${model.id}`, root.screen.name);
      }
    }
  }

  property color activeColor: model.isFocused ? Colors.mPrimary : Colors.mSecondary
  property color wsColor: model.isActive ? activeColor : Colors.mSurfaceVariant
  color: hover.hovered ? Colors.mSecondary : wsColor

  MouseArea {
    anchors.fill: parent
    anchors.margins: -Theme.marginXS
    acceptedButtons: Qt.LeftButton
    onClicked: NiriService.focusWorkspace(model.id)
  }

  Behavior on color {
    ColorAnimation {
      duration: Theme.animationFast
      easing.type: Easing.InOutQuad
    }
  }

  Behavior on implicitWidth {
    NumberAnimation {
      duration: Theme.animationFast
      easing.type: Easing.OutBack
    }
  }
}
