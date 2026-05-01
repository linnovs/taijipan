import QtQuick
import QtQuick.Layouts
import qs.Widgets
import qs.Commons

BasePanel {
  id: root

  exclusiveKeyboardFocus: true

  panelComponent: Item {
    x: (screen.width - childrenRect.width) / 2
    y: (screen.height - childrenRect.height) / 2

    ColumnLayout {
      spacing: Theme.marginSM

      UserIcon {}

      MenuButtons {}

      Uptime {}
    }
  }
}
