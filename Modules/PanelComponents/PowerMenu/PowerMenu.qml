import QtQuick
import QtQuick.Layouts
import qs.Widgets
import qs.Commons

BasePanel {
  id: root

  exclusiveKeyboardFocus: true
  panelPosition.placement: BasePanel.Placement.Center

  panelComponent: ColumnLayout {
    spacing: Theme.marginSM

    UserIcon {}

    MenuButtons {}

    Uptime {}
  }
}
