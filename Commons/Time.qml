pragma Singleton
import QtQml
import QtQuick
import Quickshell

Singleton {
  id: root

  function formatTime(date) {
    const pastDate = new Date(date);
    return Qt.formatTime(pastDate, "hh:mm");
  }

  function formatDateTime(date) {
    const dateObj = new Date(date);
    return Qt.formatDateTime(dateObj, "yyyy-MM-dd hh:mm:ss");
  }

  function formatRelativeTime(pastTime) {
    let now = Date.now();
    let diff = now - pastTime;

    let seconds = Math.floor(diff / 1000);
    let minutes = Math.floor(seconds / 60);
    let hours = Math.floor(minutes / 60);

    if (hours > 0) {
      return formatTime(pastTime);
    } else if (minutes > 0) {
      return minutes + "m ago";
    }

    return "now";
  }
}
