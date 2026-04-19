import QtQuick
import QtQuick.Controls
import qs.Widgets
import qs.Commons

Item {
  id: card

  readonly property int contentHeight: cardContent.implicitHeight

  property string appIcon
  property string imageSource
  property int urgency
  property real progress
  property date timestamp
  property string appName
  property string summary
  property string body

  property real offset: 0

  Behavior on offset {
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
    urgency: card.urgency
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

  Button {
    anchors.top: cardBackground.top
    anchors.right: cardBackground.right
    anchors.topMargin: Theme.marginXS
    anchors.rightMargin: Theme.marginXS
    icon.name: "window-close"
    icon.width: Theme.iconSizeS
    icon.height: Theme.iconSizeS
    icon.color: hovered ? Qt.alpha(Colors.mOnSurface, 0.9) : Qt.alpha(Colors.mOnSurface, 0.6)
    visible: hoverHandler.hovered
    width: icon.width
    height: icon.height
    background: Rectangle {
      color: "transparent"
    }
    onClicked: close()
  }

  NotificationCardContent {
    id: cardContent
    background: cardBackground
    appIcon: card.appIcon
    imageSource: card.imageSource
    urgency: card.urgency
    progress: card.progress
    timestamp: card.timestamp
    appName: card.appName
    summary: card.summary
    body: card.body
  }
}
