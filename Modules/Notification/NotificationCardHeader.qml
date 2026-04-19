import QtQuick
import QtQuick.Layouts
import qs.Commons

RowLayout {
  id: header

  property string appName
  property int urgency
  property date timestamp

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
