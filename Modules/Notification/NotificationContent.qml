import QtQuick
import QtQuick.Layouts
import qs.Commons

ColumnLayout {
  id: container

  required property NotificationObject notification

  spacing: Theme.marginXS

  NotificationHeader {
    notification: container.notification
  }

  NotificationBody {
    notification: container.notification
  }

  NotificationActions {
    Layout.topMargin: Theme.marginXXS
    notification: container.notification
  }
}
