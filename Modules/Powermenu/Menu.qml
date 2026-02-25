pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Widgets
import qs.Common

Rectangle {
  id: menu

  signal close()

  required property string uptimeText
  property list<LogoutButton> buttons

  implicitWidth: Theme.powerMenuWidth
  implicitHeight: Theme.powerMenuHeight
  color: Theme.mantle

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: Theme.spacing * 5

    RowLayout {
      Layout.fillWidth: true
      Layout.fillHeight: false
      Layout.preferredHeight: Theme.powerMenuStatuslineHeight

      Rectangle {
        Layout.fillHeight: true
        Layout.preferredWidth: uptimeLabel.width + uptimeLabel.anchors.leftMargin * 2

        color: Theme.mauve

        Text {
          id: uptimeLabel

          anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 10
          }

          text: "Uptime"
          color: Theme.base
          font.pixelSize: Theme.powerMenuStatuslineTextSize
          font.weight: Font.Bold
        }
      }

      Rectangle {
        Layout.fillHeight: true
        Layout.fillWidth: true

        color: Theme.surface

        Text {
          anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 10
          }

          text: menu.uptimeText
          color: Theme.text
          font.pixelSize: Theme.powerMenuStatuslineTextSize
        }
      }
    }

    RowLayout {
      spacing: Theme.spacing * 4

      Layout.alignment: Qt.AlignBottom

      Repeater {
        model: menu.buttons

        delegate: Rectangle {
          id: button
          required property LogoutButton modelData;

          implicitHeight: Theme.powerMenuButtonSize
          implicitWidth: Theme.powerMenuButtonSize
          color: ma.containsMouse ? Theme.mauve : Theme.base

          MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            onClicked: { button.modelData.exec(); menu.close() }
          }

          ColumnLayout {
            anchors.fill: parent
            spacing: 0

            ColorImageIcon {
              Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

              name: `${Quickshell.shellDir}/assets/icons/${button.modelData.icon}.png`
              isIcon: false
              width: Theme.powerMenuButtonIconSize
              height: Theme.powerMenuButtonIconSize
              color: ma.containsMouse ? Theme.base : Theme.text
            }

            Text {
              Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

              text: button.modelData.text
              font.pixelSize: Theme.powerMenuButtonTextSize
              font.weight: Font.Bold
              color: ma.containsMouse ? Theme.base : Theme.text
            }
          }
        }
      }
    }
  }
}
