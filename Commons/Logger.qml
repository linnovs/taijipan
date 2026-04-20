pragma Singleton

import QtQuick
import Quickshell

Singleton {
  id: root

  function _format(...args) {
    const maxLen = 16;
    const t = Time.formatDateTime(new Date());
    var module = "";

    if (args.length > 1) {
      module = args.shift();
    } else {
      module = "General";
    }
    module = module.substring(0, maxLen).padStart(maxLen / 2 + module.length / 2, " ").padEnd(maxLen, " ");

    return `\x1b[32m${t}\x1b[0m \x1b[35m[${module}]\x1b[0m ` + args.join(" ");
  }

  function d(...args) {
    console.debug(_format(...args));
  }

  function i(...args) {
    console.info(_format(...args));
  }

  function w(...args) {
    console.warn(_format(...args));
  }

  function e(...args) {
    console.error(_format(...args));
  }
}
