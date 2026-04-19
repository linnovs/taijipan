import QtQuick
import QtQuick.Controls
import qs.Widgets
import qs.Commons

Item {
  id: card

  readonly property int contentHeight: cardContent.implicitHeight

  required property var cardData

  property real offset: 0

  Behavior on offset {
    NumberAnimation {
      duration: Theme.animationNormal
      easing.type: Easing.InOutQuad
    }
  }

  Behavior on opacity {
    NumberAnimation {
      duration: Theme.animationNormal
      easing.type: Easing.InOutQuad
    }
  }

  Behavior on scale {
    NumberAnimation {
      duration: Theme.animationNormal
      easing.type: Easing.InOutQuad
    }
  }

  transform: Translate {
    x: offset
  }

  signal hoveredChanged(bool hovered)

  HoverHandler {
    id: hoverHandler
    onHoveredChanged: card.hoveredChanged(hovered)
  }

  NotificationCardBackground {
    id: cardBackground
    urgency: cardData.urgency
  }

  DropShadow {
    anchors.fill: cardBackground
    source: cardBackground
    autoPaddingEnabled: true
  }

  signal close

  MouseArea {
    anchors.fill: cardBackground
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: mouse => {
      if (mouse.button === Qt.RightButton)
        close();
    }
  }

  NotificationCardXButton {
    anchors.top: cardBackground.top
    anchors.right: cardBackground.right
    visible: hoverHandler.hovered
    onClicked: close()
  }

  NotificationCardContent {
    id: cardContent
    background: cardBackground
    cardData: card.cardData
  }
}
