pragma Singleton
import QtQuick
import Quickshell

Singleton {
  id: root

  function formatTime(date) {
    const pastDate = new Date(date);
    const parts = {
      hour: String(pastDate.getHours()).padStart(2, '0'),
      minute: String(pastDate.getMinutes()).padStart(2, '0')
    };

    return `${parts.hour}:${parts.minute}`;
  }

  function formatDateTime(date) {
    const parts = {
      year: String(date.getFullYear()).padStart(4, '0'),
      month: String(date.getMonth() + 1).padStart(2, '0'),
      day: String(date.getDate()).padStart(2, '0'),
      hour: String(date.getHours()).padStart(2, '0'),
      minute: String(date.getMinutes()).padStart(2, '0'),
      second: String(date.getSeconds()).padStart(2, '0')
    };

    return `${parts.year}-${parts.month}-${parts.day} ${parts.hour}:${parts.minute}:${parts.second}`;
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
