pragma Singleton
import QtQuick
import Quickshell

Singleton {
  id: root

  function _center(str, width) {
    if (str.length >= width)
      return str.substring(0, width);

    const totalPadding = width - str.length;
    const leftPadding = Math.ceil(totalPadding / 2);

    return str.padStart(leftPadding + str.length, " ").padEnd(width, " ");
  }

  function _format(...args) {
    const maxLen = 17;
    const t = Time.formatDateTime(new Date());
    const module = _center(args.length > 1 ? args.shift() : "General", maxLen);

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
    let stack = _getStackTrace();
    i("Debug", "-".repeat(52));
    i("Debug", "Call stack:");
    // Split the stack into lines and log each one
    let stackLines = stack.split("\n");
    for (let j = 0; j < stackLines.length; j++) {
      let line = stackLines[j].trim();
      if (line.length > 0) {
        i("Debug", `- ${line}`);
      }
    }
    i("Debug", "-".repeat(52));
  }
}
