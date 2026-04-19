import QtQuick
import QtQuick.Layouts
import qs.Commons

ColumnLayout {
  id: cardContent

  required property Item background
  required property var cardData

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
      imageSource: cardData.imageSource
      appIcon: cardData.appIcon
    }

    ColumnLayout {
      Layout.fillWidth: true
      spacing: Theme.marginS

      NotificationCardHeader {
        appName: cardData.appName
        urgency: cardData.urgency
        timestamp: cardData.timestamp
      }

      // Summary
      Text {
        text: cardData.summary || "Notification"
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
        text: cardData.body || ""
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
