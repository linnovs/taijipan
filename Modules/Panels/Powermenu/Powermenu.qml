pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.Widgets
import qs.Commons

Panel {
  id: root

  panelAnchorHorizontalCenter: true
  panelAnchorVerticalCenter: true

  panelContent: Item {
    property int preferredWidth: childrenRect.width
    property int preferredHeight: childrenRect.height

    ColumnLayout {
      spacing: Theme.spacing * 4

      UserIcon {
        Layout.alignment: Qt.AlignHCenter
        Layout.bottomMargin: Theme.spacing * 4
      }

      MenuButtons {
        Layout.alignment: Qt.AlignHCenter
        onCommandExecuted: root.close()
      }

      Uptime {
        Layout.alignment: Qt.AlignHCenter
      }
    }
  }
}
