import QtQuick
import QtQuick.Layouts
import qs.Commons

RowLayout {
  id: notiContent

  required property NotificationObject notification

  spacing: Theme.marginXS
  Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

  TextMetrics {
    id: textMetrics
    text: " ".repeat(Settings.data.notification.maximumCharLength)
    elide: Text.ElideRight
    font.family: Settings.data.ui.font
    font.pixelSize: Theme.fontSizeSM
  }

  Loader {
    id: imageLoader
    active: notification.image !== ""
    visible: active
    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
    Layout.preferredWidth: Theme.notificationImageSize
    Layout.preferredHeight: Theme.notificationImageSize
    sourceComponent: Image {
      source: notification.image
      sourceSize.width: parent.Layout.preferredWidth
      sourceSize.height: parent.Layout.preferredHeight
      width: parent.Layout.preferredWidth
      height: parent.Layout.preferredHeight
    }
  }

  ColumnLayout {
    spacing: Theme.marginXXS
    Layout.fillWidth: true
    Layout.minimumWidth: Theme.notificationMinimumWidth - (imageLoader.active ? imageLoader.implicitWidth : 0)
    Layout.alignment: Qt.AlignTop | Qt.AlignLeft

    Text {
      Layout.fillWidth: true
      color: Colors.mOnSurface
      maximumLineCount: 1
      font.weight: Font.DemiBold
      elide: textMetrics.elide
      text: notification.title
    }

    Text {
      Layout.maximumWidth: textMetrics.width
      color: Colors.mOnSurface
      wrapMode: Text.WordWrap
      maximumLineCount: Settings.data.notification.maximumLineCount
      elide: textMetrics.elide
      text: notification.body
    }
  }
}
