import QtQuick
import QtQuick.Layouts
import qs.Common

Item {
  id: root

  implicitWidth: childrenRect.width
  implicitHeight: Theme.barItemHeight

  RowLayout {
    spacing: Theme.spacing

    Volume {}
  }
}
