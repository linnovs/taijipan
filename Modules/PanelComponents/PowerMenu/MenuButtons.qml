import QtQuick
import QtQuick.Layouts
import qs.Commons

Item {
  readonly property var actionMetadatas: {
    "lock": {
      "icon": "lock",
      "title": "Lock",
      "command": "loginctl lock-session"
    },
    "suspend": {
      "icon": "bedtime",
      "title": "Suspend",
      "command": "systemctl suspend"
    },
    "hibernate": {
      "icon": "mode_standby",
      "title": "Hibernate",
      "command": "systemctl hibernate"
    },
    "reboot": {
      "icon": "restart_alt",
      "title": "Reboot",
      "command": "systemctl reboot"
    },
    "rebootToUEFI": {
      "icon": "reset_tv",
      "title": "Reboot to UEFI",
      "command": "bootctl reboot-to-firmware"
    },
    "logout": {
      "icon": "logout",
      "title": "Logout",
      "command": "loginctl terminate-user $USER"
    },
    "shutdown": {
      "icon": "power_settings_new",
      "title": "Shutdown",
      "command": "systemctl poweroff"
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
        options.push(actionMetadatas[option.action]);
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
        command: modelData.command
      }
    }
  }

  Layout.fillWidth: true
  Layout.preferredHeight: buttonGrid.implicitHeight
  Layout.preferredWidth: buttonGrid.implicitWidth
}
