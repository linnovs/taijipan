pragma Singleton
import QtQuick
import Quickshell

Singleton {
  id: root

  function _parseKeyEvent(event) {
    let keyString = "";
    if (event.modifiers & Qt.ControlModifier)
      keyString += "Ctrl+";
    if (event.modifiers & Qt.ShiftModifier)
      keyString += "Shift+";
    if (event.modifiers & Qt.AltModifier)
      keyString += "Alt+";

    let keyName = "";
    let rawText = event.text;

    if (event.key >= Qt.Key_A && event.key <= Qt.Key_Z || event.key >= Qt.Key_0 && event.key <= Qt.Key_9) {
      keyName = rawText.toUpperCase();
    } else if (event.key >= Qt.Key_F1 && event.key <= Qt.Key_F12) {
      keyName = `F${event.key - Qt.Key_F1 + 1}`;
    } else if (rawText && rawText.length > 0 && rawText.charCodeAt(0) >= 32 && rawText.charCodeAt(0) <= 126) {
      keyName = rawText.toUpperCase();

      if (event.modifiers & Qt.ShiftModifier) {
        const shiftedKeyMap = {
          "!": "1",
          "@": "2",
          "#": "3",
          "$": "4",
          "%": "5",
          "^": "6",
          "&": "7",
          "*": "8",
          "(": "9",
          ")": "0"
        };
        if (shiftedKeyMap[keyName])
          keyName = shiftedKeyMap[keyName];
      }
    } else {
      switch (event.key) {
      case Qt.Key_Space:
        keyName = "Space";
        break;
      case Qt.Key_Return:
        keyName = "Return";
        break;
      case Qt.Key_Enter:
        keyName = "Enter";
        break;
      case Qt.Key_Escape:
        keyName = "Esc";
        break;
      case Qt.Key_Tab:
        keyName = "Tab";
        break;
      case Qt.Key_Backspace:
        keyName = "Backspace";
        break;
      case Qt.Key_Delete:
        keyName = "Del";
        break;
      case Qt.Key_Left:
        keyName = "Left";
        break;
      case Qt.Key_Up:
        keyName = "Up";
        break;
      case Qt.Key_Right:
        keyName = "Right";
        break;
      case Qt.Key_Down:
        keyName = "Down";
        break;
      }
    }

    if (keyName === "")
      return "";

    return keyString + keyName;
  }

  function isKeybindPressed(event, keybinds) {
    for (var i = 0; i < keybinds.length; i++) {
      if (_parseKeyEvent(event) === keybinds[i]) {
        return true;
      }
    }
    return false;
  }
}
