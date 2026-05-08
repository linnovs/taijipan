import QtQuick
import qs.Commons

Item {
  id: root

  required property LockContext context

  Text {
    anchors.centerIn: parent
    text: context.message
    color: context.isErrorMessage ? Colors.mError : Colors.mOnSurface
    font.pixelSize: Theme.fontSizeLG
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
  }

  implicitWidth: Theme.widthMD
  implicitHeight: Theme.heightXXS
}
