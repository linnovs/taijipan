import QtQuick
import QtQuick.Controls
import qs.Commons

Button {
  anchors.topMargin: Theme.marginXS
  anchors.rightMargin: Theme.marginXS
  icon.name: "window-close"
  icon.width: Theme.iconSizeS
  icon.height: Theme.iconSizeS
  icon.color: hovered ? Qt.alpha(Colors.mOnSurface, 0.9) : Qt.alpha(Colors.mOnSurface, 0.6)
  width: icon.width
  height: icon.height
  background: Rectangle {
    color: "transparent"
  }
}
