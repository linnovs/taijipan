import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons

RowLayout {
  id: header

  required property NotificationObject notification

  spacing: Theme.marginXS
  Layout.fillWidth: true
  Layout.maximumHeight: Theme.notificationAppIconSize
  Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

  Image {
    id: appIcon
    Layout.preferredWidth: Theme.notificationAppIconSize
    Layout.preferredHeight: Theme.notificationAppIconSize
    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
    sourceSize.width: Layout.preferredWidth
    sourceSize.height: Layout.preferredHeight
    source: Paths.isFileUrl(notification.icon) ? notification.icon : Quickshell.iconPath(notification.icon, "bell")
  }

  Text {
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
    text: notification.appName
    color: Colors.mOnSurfaceVariant
    verticalAlignment: Text.AlignVCenter
    font.pixelSize: Theme.fontSizeMD
    font.weight: Font.Light
  }

  Text {
    id: timestamp
    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
    color: Colors.mOnSurfaceVariant
    verticalAlignment: Text.AlignVCenter
    font.pixelSize: Theme.fontSizeSM
    font.weight: Font.Medium

    Timer {
      interval: 1000
      running: true
      repeat: true
      triggeredOnStart: true
      onTriggered: timestamp.text = Time.formatRelativeTime(notification.timestamp)
    }
  }
}
