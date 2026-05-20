import QtQuick
import Quickshell
import qs.Services
import qs.Commons

Item {
  id: root

  required property ShellScreen screen

  property var popupWindow: null

  // model structure: [{ index, icon, iconFill, isImage, label, action, isSeparator }, ...]
  property ListModel model: ListModel {}

  signal triggered(string action, var item)

  function open(globalPos) {
    if (!popupWindow)
      return;
    popupWindow.showContextMenu(model, globalPos, function (action, item) {
      root.triggered(action, item);
      return true;
    });
  }

  function close() {
    if (!popupWindow)
      return;
    popupWindow.hideContextMenu();
  }

  Component.onCompleted: popupWindow = PanelService.getPopupWindow(screen)
}
