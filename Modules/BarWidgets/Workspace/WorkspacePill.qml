import QtQuick
import qs.Services
import qs.Commons

Rectangle {
  required property var model

  property int activeWidth
  property int inactiveWidth
  property int pillHeight

  implicitWidth: model.isActive ? activeWidth : inactiveWidth
  implicitHeight: pillHeight
  radius: Theme.radiusRound

  HoverHandler {
    id: hover
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
