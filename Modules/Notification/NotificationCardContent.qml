import QtQuick
import QtQuick.Layouts
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

    NotificationCardImage {
      imageSource: cardContent.imageSource
      appIcon: cardContent.appIcon
    }

    ColumnLayout {
      Layout.fillWidth: true
      spacing: Theme.marginS

      NotificationCardHeader {
        appName: cardContent.appName
        urgency: cardContent.urgency
        timestamp: cardContent.timestamp
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
