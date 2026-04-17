import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts
import Quickshell.Wayland

Rectangle {
  id: root

  required property LockContext ctx

  color: "#1e1e2e"

  Button {
    text: "Not working, let me out"
    onClicked: root.ctx.unlocked()
  }

  Label {
    id: clock

    property var date: new Date()

    anchors.top: parent.top
    anchors.right: parent.right
    anchors.rightMargin: 20
    anchors.topMargin: 20
    font.family: "JetBrains Mono"
    font.pointSize: 72
    text: {
      const hours = this.date.getHours().toString().padStart(2, '0');
      const minutes = this.date.getMinutes().toString().padStart(2, '0');
      return `${hours}:${minutes}`;
    }
  }

  Label {
    id: date

    property var date: new Date()

    anchors.top: clock.bottom
    anchors.right: clock.right
    anchors.topMargin: 0
    text: {
      return `${this.date}`;
    }
  }
}
