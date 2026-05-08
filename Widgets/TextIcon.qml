import QtQuick
import qs.Commons

Text {
  property string icon: Icons.defaultIcon
  property int iconSize: Theme.fontSizeMD
  property bool fill: false

  visible: (icon !== undefined) && (icon !== "")
  text: {
    if (icon === undefined || icon === "") {
      return "";
    }

    if (Icons.get(icon) === undefined) {
      Logger.w("Icons", `"${icon}"`, "not found in the icons font");
      Logger.callStack();
      return Icons.get(Icons.defaultIcon);
    }

    return Icons.get(icon);
  }
  font.family: Icons.fontFamily
  font.pointSize: iconSize
  font.variableAxes: {
    "FILL": fill ? 1 : 0,
    "wght": 400,
    "GRAD": 0,
    "opsz": 48
  }
  color: Colors.mOnSurface
  verticalAlignment: Text.AlignVCenter
  horizontalAlignment: Text.AlignHCenter
}
