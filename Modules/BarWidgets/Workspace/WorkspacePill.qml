import QtQuick
import QtQuick.Layouts
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

  color: hover.hovered ? Colors.mSecondary : model.isActive && model.isFocused ? Colors.mPrimary : Colors.mSurfaceVariant

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton
    onClicked: NiriService.focusWorkspace(model.id)
  }

  Behavior on color {
    ColorAnimation {
      duration: Theme.animationFastest
      easing.type: Easing.InOutQuad
    }
  }

  Behavior on Layout.preferredWidth {
    NumberAnimation {
      duration: Theme.animationFastest
      easing.type: Easing.OutBack
    }
  }
}
