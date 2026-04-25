pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import qs.Commons

Singleton {
  id: root

  property bool initialized: false
  property bool isSettingVolume: false

  readonly property var sink: Pipewire.ready ? Pipewire.defaultAudioSink : null
  readonly property real maxVolume: 1.5

  property bool hasWpctl: false
  property bool wpctlStateValid: false
  property real wpctlVolume: 0
  property bool wpctlMuted: false

  function clampVolume(vol: real): real {
    return Math.max(0, Math.min(vol, maxVolume));
  }

  readonly property real volume: {
    if (hasWpctl && wpctlStateValid)
      return clampVolume(wpctlVolume);
    if (!sink?.audio)
      return 0;
    return clampVolume(sink.audio.volume);
  }

  readonly property bool muted: {
    if (hasWpctl && wpctlStateValid)
      return wpctlMuted;
    return sink?.audio?.muted ?? true;
  }

  PwObjectTracker {
    objects: root.sink ? [root.sink] : []
  }

  function applyWpctlState(raw: string): bool {
    const text = String(raw || "").trim();
    const match = text.match(/Volume:\s*([0-9]*\.?[0-9]+)/i);
    if (!match || match.length < 2) {
      return false;
    }

    const parsdVolume = parseFloat(match[1]);
    if (isNaN(parsdVolume)) {
      return false;
    }

    wpctlVolume = parsdVolume;
    wpctlMuted = /\[MUTED\]/i.test(text);
    wpctlStateValid = true;

    if (!root.initialized) {
      root.initialized = true;
      Logger.i("AudioService", "initialized with volume " + wpctlVolume + " and muted state " + wpctlMuted);
    }

    return true;
  }

  Process {
    id: wpctlStateProcess
    stdout: StdioCollector {}
    onExited: exitCode => {
      if (exitCode !== 0 || !root.applyWpctlState(stdout.text))
        wpctlStateValid = false;
    }
  }

  function refreshWpctlState() {
    if (!hasWpctl || wpctlStateProcess.running)
      return;

    wpctlStateProcess.command = ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"];
    wpctlStateProcess.running = true;
  }

  Process {
    id: checkWpctlProcess
    command: ["sh", "-c", "command -v wpctl"]
    onExited: exitCode => {
      root.hasWpctl = exitCode === 0;
      if (root.hasWpctl)
        root.refreshWpctlState();
      else
        Logger.i("AudioService", "wpctl not found in PATH, will use Pipewire API directly without wpctl state synchronization");
    }
  }

  Connections {
    target: sink?.audio ?? null
    function onVolumeChanged() {
      if (root.hasWpctl)
        root.refreshWpctlState();

      if (root.isSettingVolume || !root.sink?.audio)
        return;

      const vol = root.sink.audio.volume;
      if (vol === undefined || isNaN(vol))
        return;

      if (vol > root.maxVolume) {
        root.isSettingVolume = true;
        Qt.callLater(() => {
          if (root.sink?.audio && root.sink.audio.volume > root.maxVolume) {
            root.sink.audio.volume = root.maxVolume;
            root.isSettingVolume = false;
          }
        });
      }
    }
    function onMutedChanged() {
      if (root.hasWpctl)
        root.refreshWpctlState();
    }
  }

  Component.onCompleted: {
    checkWpctlProcess.running = true;
  }
}
