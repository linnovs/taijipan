import QtQuick
import QtQuick.Layouts
import qs.Widgets
import qs.Commons

BasePanel {
  id: root

  exclusiveKeyboardFocus: true

  panelComponent: Item {
    ColumnLayout {
      y: (screen.height - implicitHeight) / 2
      width: screen.width
      spacing: Theme.marginSM

      UserIcon {}

      MenuButtons {}

      Uptime {}
    }
  }
}
