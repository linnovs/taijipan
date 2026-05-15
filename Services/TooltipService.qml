pragma Singleton
import QtQuick
import Quickshell
import qs.Commons

Singleton {
  id: root

  signal showTooltip(string title, string description, string screenName, int positionX, int positionY)

  signal hideTooltip(string screenName)

  property var tooltips: ({})

  function registerTooltip(title, description, screenName) {
    const tooltipId = Checksum.sha256(`${title}|${description}|${screenName}`);
    tooltips[tooltipId] = {
      title: title,
      description: description,
      screenName: screenName
    };
  }

  function unregisterTooltip(title, description, screenName) {
    const tooltipId = Checksum.sha256(`${title}|${description}|${screenName}`);
    delete tooltips[tooltipId];
  }

  function show(tooltipId, positionX, positionY) {
    const tooltip = tooltips[tooltipId];
    if (!tooltip)
      return;

    root.showTooltip(tooltip.title, tooltip.description, tooltip.screenName, positionX, positionY);
  }

  function hide(tooltipId) {
    const tooltip = tooltips[tooltipId];
    if (!tooltip)
      return;

    root.hideTooltip(tooltip.screenName);
  }
}
