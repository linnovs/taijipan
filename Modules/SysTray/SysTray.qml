import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.SystemTray

Variants {
  model: Quickshell.screens
  delegate: PanelWindow {
    id: root
    required property ShellScreen modelData

    screen: modelData
    anchors.top: true
    anchors.right: true
    implicitWidth: screen ? screen.width : 200
    implicitHeight: 30

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "taijipan-systray-" + (screen?.name || "unknown")

    color: "transparent"

    RowLayout {
      id: container
      anchors.top: parent.top
      anchors.right: parent.right
      anchors.topMargin: 3

      Repeater {
        model: SystemTray.items
        delegate: Item {
          id: item

          Image {
            source: modelData.icon
            sourceSize: Qt.size(24, 24)
          }

          MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: mouse => {
              if (mouse.button === Qt.LeftButton) {
                modelData.activate();
                return;
              }

              if (mouse.button === Qt.RightButton) {
                const windowPos = mapToItem(null, mouse.x, mouse.y);
                modelData.display(root, windowPos.x, windowPos.y);
                return;
              }
            }
          }

          Layout.preferredWidth: 24
          Layout.preferredHeight: 24
        }
      }
    }
  }
}
