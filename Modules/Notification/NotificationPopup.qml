import QtQuick
import qs.Services
import qs.Widgets
import qs.Commons

Item {
  id: popup

  required property var modelData
  property bool dismissing: false
  property string notificationId: modelData.id

  readonly property int minimumWidth: Theme.widthSM
  readonly property int minimumHeight: Theme.heightXXS

  scale: 0.8
  Behavior on scale {
    NumberAnimation {
      duration: Theme.animationNormal
      easing.type: Easing.OutBack
    }
  }

  opacity: 0
  Behavior on opacity {
    NumberAnimation {
      duration: Theme.animationNormal
      easing.type: Easing.Linear
    }
  }

  Behavior on y {
    NumberAnimation {
      duration: Theme.animationNormal
      easing.type: Easing.OutCubic
    }
  }

  Component.onCompleted: {
    scale = 1.0;
    opacity = Settings.data.notification.backgroundOpacity;
  }

  Timer {
    id: dismissTimer
    interval: Theme.animationBuffer
    onTriggered: NotificationService.dismissPopup(notificationId)
  }

  function dismiss() {
    dismissing = true;
    z = -1;
    y = -implicitHeight;
    scale = 0.8;
    opacity = 0;
    dismissTimer.restart();
  }

  DragHandler {
    acceptedButtons: Qt.LeftButton
    xAxis.minimum: 0
    xAxis.maximum: parent.width
    yAxis.enabled: false
    onActiveChanged: {
      if (active) {
        parent.opacity = parent.x / parent.width;
        return;
      }

      if (parent.x > parent.width * 0.8) {
        popup.dismiss();
      } else {
        parent.x = 0;
        parent.opacity = Settings.data.notification.backgroundOpacity;
      }
    }
  }

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.RightButton
    onClicked: mouse => {
      if (mouse.button === Qt.RightButton)
        popup.dismiss();
    }
  }

  Rectangle {
    id: background
    anchors.fill: parent
    radius: Theme.radiusLG
    color: Colors.mSurface

    Rectangle {
      anchors.top: parent.top
      anchors.horizontalCenter: parent.horizontalCenter
      width: (parent.width - background.radius * 2) * modelData.progress
      height: 2
      color: Colors.mPrimary

      Behavior on width {
        NumberAnimation {
          duration: Theme.animationBuffer
          easing.type: Easing.Linear
        }
      }
    }
  }

  DropShadow {
    anchors.fill: background
    source: background
    autoPaddingEnabled: true
  }

  NotificationContent {
    id: content
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin: Theme.marginXS
    minimumWidth: parent.minimumWidth
    notification: NotificationObject {
      notificationId: popup.notificationId
      icon: modelData.icon
      appName: modelData.appName
      title: modelData.title
      body: modelData.body
      image: modelData.image
      hasActionIcons: modelData.hasActionIcons
      actions: modelData.actions
      timestamp: modelData.timestamp
    }
  }

  implicitWidth: Math.max(minimumWidth, content.implicitWidth) + Theme.marginXS * 2
  implicitHeight: Math.max(minimumHeight, content.implicitHeight) + Theme.marginXS * 2
}
