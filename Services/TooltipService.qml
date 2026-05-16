pragma Singleton
import QtQuick
import Quickshell
import qs.Commons

Singleton {
  id: root

  signal showTooltip(string title, string description, string screenName, int positionX, int positionY)

  signal hideTooltip(string screenName)

  property var tooltips: ({})

  function registerTooltip(title, description, screenName): string {
    const tooltipId = Checksum.sha256(`${title}|${description}|${screenName}`);
    tooltips[tooltipId] = {
      title: title,
      description: description,
      screenName: screenName
    };
    tooltips = Object.assign({}, tooltips);
    Logger.d("TooltipService", "Registered tooltip:", title, "-", description, "- for screen:", screenName, "- with id:", tooltipId);
    return tooltipId;
  }

  function unregisterTooltip(title, description, screenName) {
    const tooltipId = Checksum.sha256(`${title}|${description}|${screenName}`);
    delete tooltips[tooltipId];
    tooltips = Object.assign({}, tooltips);
    Logger.d("TooltipService", "Unregistered tooltip:", title, "-", description, "- for screen:", screenName, "- with id:", tooltipId);
  }

  function show(tooltipId, positionX, positionY) {
    const tooltip = tooltips[tooltipId];
    if (!tooltip)
      return;

    Logger.d("TooltipService", "Showing tooltip:", tooltip.title, "-", tooltip.description, "- for screen:", tooltip.screenName, "- at position:", positionX, positionY);
    root.showTooltip(tooltip.title, tooltip.description, tooltip.screenName, positionX, positionY);
  }

  function hide(tooltipId) {
    const tooltip = tooltips[tooltipId];
    if (!tooltip)
      return;

    root.hideTooltip(tooltip.screenName);
  }
}
