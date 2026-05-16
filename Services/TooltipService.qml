pragma Singleton
import QtQuick
import Quickshell
import qs.Commons

Singleton {
  id: root

  property ListModel tooltips: ListModel {}

  function show(id, title, description, screenName, positionX, positionY) {
    for (let i = 0; i < tooltips.count; i++) {
      const tooltip = tooltips.get(i);
      if (tooltip.id === id) {
        tooltips.setProperty(i, "title", title);
        tooltips.setProperty(i, "description", description);
        tooltips.setProperty(i, "screenName", screenName);
        tooltips.setProperty(i, "positionX", positionX);
        tooltips.setProperty(i, "positionY", positionY);
        tooltips.setProperty(i, "createdAt", Date.now());

        return;
      }
    }

    tooltips.append({
      id,
      title,
      description,
      screenName,
      positionX,
      positionY,
      isClosing: false,
      createdAt: Date.now()
    });
  }

  Timer {
    id: tooltipCleanupTimer
    running: tooltips.count > 0
    interval: Theme.timerDebounceLong
    repeat: true
    onTriggered: {
      for (let i = tooltips.count - 1; i >= 0; i--) {
        const tooltip = tooltips.get(i);
        if (tooltip.isClosing || tooltip.createdAt + (Settings.data.tooltip.ttl * 1000) < Date.now())
          tooltips.remove(i);
      }
    }
  }

  function hide(id, screenName) {
    for (let i = 0; i < tooltips.count; i++) {
      const tooltip = tooltips.get(i);
      if (tooltip.id === id && tooltip.screenName === screenName) {
        tooltips.setProperty(i, "isClosing", true);
        return;
      }
    }
  }
}
