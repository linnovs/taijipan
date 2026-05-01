import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.Widgets
import qs.Commons

Rectangle {
  id: root

  property string icon
  property string title
  property string command

  color: Colors.mSurface
  radius: Theme.radiusMD

  Process {
    id: actionProcess
    running: false
    command: ["sh", "-c", root.command]
  }

  ColumnLayout {
    id: buttonLayout
    anchors.centerIn: parent
    spacing: Theme.marginXS

    TextIcon {
      id: textIcon

      Layout.preferredWidth: textIcon.implicitWidth
      Layout.preferredHeight: textIcon.implicitHeight
      Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

      icon: root.icon
      iconSize: Theme.powerMenuButtonIconSize
    }

    Text {
      id: titleText

      Layout.preferredWidth: titleText.implicitWidth
      Layout.preferredHeight: titleText.implicitHeight
      Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

      color: Colors.mOnSurface
      text: root.title
      font.weight: Font.DemiBold
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignHCenter
    }
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    onHoveredChanged: {
      root.color = containsMouse ? Colors.mInverseSurface : Colors.mSurface;
      textIcon.color = containsMouse ? Colors.mInverseOnSurface : Colors.mOnSurface;
      titleText.color = containsMouse ? Colors.mInverseOnSurface : Colors.mOnSurface;
    }
    onClicked: actionProcess.running = true
  }

  Layout.preferredWidth: Math.max(buttonLayout.implicitWidth, buttonLayout.implicitHeight) + Theme.marginXS
  Layout.preferredHeight: Math.max(buttonLayout.implicitWidth, buttonLayout.implicitHeight) + Theme.marginXS
}
