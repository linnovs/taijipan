import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Services
import qs.Widgets
import qs.Commons

Item {
  id: popup

  required property var modelData
  property bool dismissing: false
  property string notificationId: modelData.id

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
    notification: NotificationObject {
      icon: modelData.icon
      appName: modelData.appName
      title: modelData.title
      body: modelData.body
      image: modelData.image
      timestamp: modelData.timestamp
    }
  }

  implicitWidth: Math.max(Theme.notificationMinimumWidth, content.implicitWidth) + Theme.marginXS * 2
  implicitHeight: Math.max(Theme.notificationMinimumHeight, content.implicitHeight) + Theme.marginXS * 2
}
