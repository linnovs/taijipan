import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Services
import qs.Commons

FlexboxLayout {
  id: actions

  required property NotificationObject notification

  visible: notification.actions.count > 0
  gap: Theme.marginXS

  Repeater {
    model: notification.actions
    Rectangle {
      id: buttonContainer

      required property var modelData
      property bool hovered: false

      MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton
        onContainsMouseChanged: hovered = containsMouse
        onClicked: mouse => {
          if (mouse.button !== Qt.LeftButton)
            return;

          const notificationId = notification.notificationId;
          const identifier = modelData.identifier;
          const invoked = NotificationService.invokeAction(notificationId, identifier);
          if (invoked) {
            Logger.d("NotificationActions", "Invoked action", `'${identifier}'`, "for notification", `'${notificationId}'`);
          }
        }
        z: 10
      }

      Layout.fillWidth: true

      color: hovered ? Colors.mSurfaceContainerHigh : Colors.mSurfaceContainerLow
      radius: Theme.radiusLG

      RowLayout {
        id: buttonContent
        anchors.centerIn: parent
        spacing: Theme.marginSM

        Loader {
          active: notification.hasActionIcons && Quickshell.hasThemeIcon(modelData.identifier)
          visible: active
          sourceComponent: Image {
            source: Quickshell.iconPath(modelData.identifier, true)
            sourceSize.width: Theme.fontSizeMD
            sourceSize.height: Theme.fontSizeMD
          }
        }

        Text {
          text: modelData.text
          font.pixelSize: Theme.fontSizeMD
          color: Colors.mOnSurface
        }
      }

      implicitWidth: buttonContent.implicitWidth + Theme.marginXS * 2
      implicitHeight: buttonContent.implicitHeight + Theme.marginXS * 2
    }
  }
}
