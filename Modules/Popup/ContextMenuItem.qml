import QtQuick
import QtQuick.Layouts
import qs.Widgets
import qs.Commons

Rectangle {
  id: root

  required property var modelData
  readonly property bool isSeparator: modelData.isSeparator

  Layout.preferredWidth: parent.width
  Layout.preferredHeight: isSeparator ? Theme.marginXXS : Math.max(textMetrics.height, iconMetrics.iconSize) + Theme.marginXXS * 2
  radius: Theme.radiusSM

  signal triggered(string action, var item)

  MouseArea {
    id: ma
    acceptedButtons: Qt.LeftButton
    anchors.fill: parent
    hoverEnabled: true
    onClicked: root.triggered(modelData.action || "unknown", modelData)
  }

  color: !isSeparator && ma.containsMouse ? Colors.mPrimary : "transparent"

  readonly property bool haveIcon: modelData.icon !== undefined && modelData.icon !== ""
  readonly property bool isIcon: haveIcon && !modelData.isImage
  readonly property bool isImage: haveIcon && modelData.isImage

  RowLayout {
    anchors.fill: parent
    anchors.leftMargin: Theme.marginXS
    anchors.rightMargin: Theme.marginXS
    spacing: Theme.spacing

    Rectangle {
      id: separator
      visible: isSeparator
      Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
      Layout.preferredWidth: parent.width - Theme.marginXXS
      Layout.preferredHeight: 1
      color: Colors.mSurfaceVariant
    }

    Rectangle {
      visible: !isSeparator && !haveIcon
      color: "transparent"
      Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
      Layout.preferredWidth: iconMetrics.iconSize
      Layout.preferredHeight: iconMetrics.iconSize
    }

    TextIcon {
      visible: !isSeparator && isIcon
      Layout.alignment: Qt.AlignVCenter
      icon: isIcon ? modelData.icon : ""
      iconSize: iconMetrics.iconSize
      Layout.preferredWidth: iconMetrics.iconSize
      Layout.preferredHeight: iconMetrics.iconSize
      fill: modelData.iconFill === true
      color: ma.containsMouse ? Colors.mOnPrimary : Colors.mOnSurface
    }

    ColoredImage {
      visible: !isSeparator && isImage
      Layout.alignment: Qt.AlignVCenter
      source: isImage ? modelData.icon : ""
      sourceSize: Qt.size(iconMetrics.iconSize, iconMetrics.iconSize)
      Layout.preferredHeight: iconMetrics.iconSize
      Layout.preferredWidth: iconMetrics.iconSize
      colorizationColor: ma.containsMouse ? Colors.mOnPrimary : Colors.mOnSurface
    }

    Text {
      visible: !isSeparator
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
      text: modelData.label || ""
      font.family: textMetrics.font.family
      font.pixelSize: textMetrics.font.pixelSize
      wrapMode: Text.NoWrap
      elide: Text.ElideNone
      color: ma.containsMouse ? Colors.mOnPrimary : Colors.mOnSurface
    }
  }
}
