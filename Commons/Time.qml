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
