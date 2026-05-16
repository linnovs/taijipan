pragma Singleton
import QtQuick
import Quickshell
import qs.Commons

Singleton {
  id: root

  signal showTooltip(string title, string description, string screenName, int positionX, int positionY)

  signal hideTooltip(string screenName)
}
