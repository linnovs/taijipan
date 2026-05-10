import QtQuick
import QtQuick.Layouts
import qs.Commons

Item {
  readonly property var actionMetadatas: {
    "lock": {
      "icon": "lock",
      "title": "Lock"
    },
    "suspend": {
      "icon": "bedtime",
      "title": "Suspend"
    },
    "hibernate": {
      "icon": "mode_standby",
      "title": "Hibernate"
    },
    "reboot": {
      "icon": "restart_alt",
      "title": "Reboot"
    },
    "rebootToUEFI": {
      "icon": "reset_tv",
      "title": "Reboot to UEFI"
    },
    "logout": {
      "icon": "logout",
      "title": "Logout"
    },
    "shutdown": {
      "icon": "power_settings_new",
      "title": "Shutdown"
    }
  }

  property int _optionsVersion: 0
  property var options: {
    void (_optionsVersion);
    let options = [];
    let fromSettings = Settings.data.powerMenu.options || [];

    for (let i = 0; i < fromSettings.length; i++) {
      let option = fromSettings[i];
      if (actionMetadatas[option.action]) {
        let obj = Object.assign({}, actionMetadatas[option.action], {
          action: option.action
        });
        options.push(obj);
      }
    }

    return options;
  }

  Connections {
    target: Settings.data.powerMenu
    function onOptionsChanged() {
      _optionsVersion++;
    }
  }

  GridLayout {
    id: buttonGrid
    anchors.centerIn: parent
    rowSpacing: Theme.marginSM
    columnSpacing: Theme.marginSM

    Repeater {
      model: options
      delegate: ActionButton {
        icon: modelData.icon
        title: modelData.title
        action: modelData.action
      }
    }
  }

  Layout.fillWidth: true
  Layout.preferredHeight: buttonGrid.implicitHeight
  Layout.preferredWidth: buttonGrid.implicitWidth
}
