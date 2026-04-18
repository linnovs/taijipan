import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons

ColumnLayout {
  id: cardContent

  required property Item background

  property string appIcon
  property string imageSource
  property int urgency
  property real progress
  property date timestamp
  property string appName
  property string summary
  property string body

  anchors.fill: background
  anchors.margins: Theme.marginM
  spacing: Theme.marginM

  RowLayout {
    spacing: Theme.marginL

    Layout.fillWidth: true
    Layout.topMargin: Theme.marginM
    Layout.rightMargin: Theme.marginM
    Layout.bottomMargin: Theme.marginM
    Layout.leftMargin: Theme.marginM

    Image {
      Layout.preferredWidth: Theme.iconSizeL
      Layout.preferredHeight: Theme.iconSizeL
      Layout.alignment: Qt.AlignTop
      source: imageSource || Quickshell.iconPath(appIcon, true) || Quickshell("bell")
      sourceSize: Qt.size(width, height)

      Loader {
        active: imageSource && appIcon
        anchors.fill: parent
        Image {
          width: Theme.iconSizeXS
          height: Theme.iconSizeXS
          source: Quickshell.iconPath(appIcon, true) || appIcon
          sourceSize: Qt.size(width, height)
          anchors.right: parent.right
          anchors.bottom: parent.bottom
        }
      }
    }

    ColumnLayout {
      Layout.fillWidth: true
      spacing: Theme.marginS

      // Header
      RowLayout {
        Layout.fillWidth: true
        spacing: Theme.marginS

        Rectangle {
          Layout.preferredWidth: 6
          Layout.preferredHeight: 6
          Layout.alignment: Qt.AlignVCenter
          radius: Theme.radiusS
          color: urgency === 2 ? Colors.mError : urgency === 0 ? Colors.mOnSurface : Colors.mPrimary
        }

        Text {
          text: appName || "Unknown App"
          font.pointSize: Theme.fontSizeS
          font.weight: Font.Bold
          color: Colors.mSecondary
          verticalAlignment: Text.AlignVCenter
        }

        Item {
          Layout.fillWidth: true
        }

        Text {
          textFormat: Text.PlainText
          font.pointSize: Theme.fontSizeXS
          font.weight: Font.Light
          color: Colors.mOnSurfaceVariant
          verticalAlignment: Text.AlignVCenter
          Layout.alignment: Qt.AlignVCenter

          Timer {
            interval: 60 * 1000
            repeat: true
            running: true
            triggeredOnStart: true
            onTriggered: parent.text = " " + Time.formatRelativeTime(timestamp)
          }
        }
      }

      // Summary
      Text {
        text: summary || "Notification"
        font.pointSize: Theme.fontSizeM
        font.weight: Font.Medium
        color: Colors.mOnSurface
        textFormat: Text.StyledText
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        maximumLineCount: 3
        elide: Text.ElideRight
        visible: text.length > 0
        Layout.fillWidth: true
        Layout.rightMargin: Theme.marginM
      }

      // Body
      Text {
        text: body || ""
        font.pointSize: Theme.fontSizeM
        color: Colors.mOnSurface
        textFormat: Text.StyledText
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        maximumLineCount: 5
        elide: Text.ElideRight
        visible: text.length > 0
        Layout.fillWidth: true
        Layout.rightMargin: Theme.marginM
      }
    }
  }
}
