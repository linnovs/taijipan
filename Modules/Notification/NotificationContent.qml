import QtQuick
import QtQuick.Layouts
import qs.Commons

ColumnLayout {
  id: container

  required property NotificationObject notification
  property int minimumWidth

  spacing: Theme.marginXS

  NotificationHeader {
    notification: container.notification
  }

  NotificationBody {
    Layout.minimumWidth: container.minimumWidth
    notification: container.notification
  }

  NotificationActions {
    Layout.topMargin: Theme.marginXXS
    notification: container.notification
  }
}
