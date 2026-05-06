import QtQuick
import QtQuick.Layouts
import qs.Services
import qs.Commons

ColumnLayout {
  id: container

  required property NotificationObject notification
  property int minimumWidth

  HoverHandler {
    onHoveredChanged: {
      if (hovered) {
        NotificationService.hover(notification.notificationId);
      } else {
        NotificationService.clearHover(notification.notificationId);
      }
    }
  }

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
