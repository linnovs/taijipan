import QtQuick
import qs.Services
import qs.Commons

Rectangle {
  id: root
  required property var model
  property var screen

  property int activeWidth
  property int inactiveWidth
  property int pillHeight

  implicitWidth: model.isActive ? activeWidth : inactiveWidth
  implicitHeight: pillHeight
  radius: Theme.radiusRound

  property string tooltipId

  HoverHandler {
    id: hover
    margin: Theme.marginXS
    onHoveredChanged: {
      if (!tooltipId)
        return;

      if (hover.hovered) {
        const atPoint = root.mapToGlobal(Qt.point(0, root.height + Theme.marginXXS));
        TooltipService.show(tooltipId, atPoint.x, atPoint.y);
      } else {
        TooltipService.hide(tooltipId);
      }
    }
  }

  Component.onCompleted: {
    if (!model.name)
      return;
    tooltipId = TooltipService.registerTooltip(model.name, "", screen.name);
  }

  Component.onDestruction: {
    if (!tooltipId)
      return;
    TooltipService.unregisterTooltip(model.name, "", screen.name);
  }

  property color wsColor: model.isActive && model.isFocused ? Colors.mPrimary : Colors.mSurfaceVariant
  color: hover.hovered ? Colors.mSecondary : wsColor

  MouseArea {
    anchors.fill: parent
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
