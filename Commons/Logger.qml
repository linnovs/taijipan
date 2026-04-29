pragma Singleton
import QtQuick
import Quickshell

Singleton {
  id: root

  function _format(...args) {
    const maxLen = 17;
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
    if (Settings?.data.debug) {
      console.debug(_format(...args));
    }
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

  function _getStackTrace() {
    try {
      throw new Error();
    } catch (e) {
      return e.stack;
    }
  }

  function callStack() {
    var stack = _getStackTrace();
    i("Debug", "-".repeat(52));
    i("Debug", "Call stack:");
    // Split the stack into lines and log each one
    var stackLines = stack.split("\n");
    for (var j = 0; j < stackLines.length; j++) {
      var line = stackLines[j].trim();
      if (line.length > 0) {
        i("Debug", `- ${line}`);
      }
    }
    i("Debug", "-".repeat(52));
  }
}
