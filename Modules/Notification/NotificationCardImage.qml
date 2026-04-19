import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons

Image {
  id: notificationImage

  property string imageSource
  property string appIcon

  Layout.preferredWidth: Theme.iconSizeL
  Layout.preferredHeight: Theme.iconSizeL
  Layout.alignment: Qt.AlignTop
  source: imageSource || Quickshell.iconPath(appIcon, true) || Quickshell.iconPath("bell")
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
