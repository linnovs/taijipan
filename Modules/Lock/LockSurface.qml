import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
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

    anchors {
      top: parent.top
      right: parent.right
      rightMargin: 20
      topMargin: 20
    }

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

    anchors {
      top: clock.bottom
      right: clock.right
      topMargin: 0
    }

    text: {
      return `${this.date}`
    }
  }
}
