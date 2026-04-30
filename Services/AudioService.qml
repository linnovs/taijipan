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

  property int lastVolumeFeedbackTime: 0
  readonly property int volumeFeedbackInterval: 100

  readonly property var sink: Pipewire.ready ? Pipewire.defaultAudioSink : null
  readonly property real maxVolume: 1.5
  readonly property real epsilon: 0.005

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
      Logger.i("AudioService", "Initialized with volume " + wpctlVolume + " and muted state " + wpctlMuted);
    }

    return true;
  }

  Process {
    id: wpctlStateProcess
    stdout: StdioCollector {}
  }

  Connections {
    target: wpctlStateProcess
    function onExited(exitCode) {
      if (exitCode !== 0 || !root.applyWpctlState(wpctlStateProcess.stdout.text))
        wpctlStateValid = false;
    }
  }

  function refreshWpctlState() {
    if (!hasWpctl || wpctlStateProcess.running)
      return;

    wpctlStateProcess.command = ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"];
    wpctlStateProcess.running = true;
  }

  function playFeedbackSound(vol: real) {
    if (!Settings.data.audio.volumeFeedback)
      return;

    const now = Date.now();
    if (now - lastVolumeFeedbackTime < volumeFeedbackInterval)
      return;
    lastVolumeFeedbackTime = now;

    SoundService.playSound("volumeFeedback", vol);
  }

  Process {
    id: wpctlSetProcess
    stdout: StdioCollector {}
  }

  Connections {
    target: wpctlSetProcess
    function onExited(exitCode) {
      if (exitCode !== 0)
        Logger.w("AudioService", "Failed to set volume with wpctl, exit code:", exitCode, "stderr:", stdout.text);
    }
  }

  function setVolume(vol: real) {
    if (!Pipewire.ready || (!sink?.audio && !hasWpctl)) {
      Logger.w("AudioService", "No audio sink available to set volume");
      return;
    }

    const clampedVol = clampVolume(vol);
    if (Math.abs(clampedVol - volume) < root.epsilon)
      return;

    if (hasWpctl) {
      if (wpctlSetProcess.running)
        return;

      isSettingVolume = true;
      wpctlMuted = false;
      wpctlVolume = clampedVol;
      wpctlStateValid = true;

      const volPercent = Math.round(clampedVol * 10000) / 100;
      wpctlSetProcess.command = ["sh", "-c", `wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume @DEFAULT_AUDIO_SINK@ ${volPercent}%`];
      wpctlSetProcess.running = true;

      playFeedbackSound(clampedVol);
      return;
    }

    if (!sink?.ready || !sink?.audio) {
      Logger.w("AudioService", "Audio sink not ready to set volume");
      return;
    }

    isSettingVolume = true;
    sink.audio.muted = false;
    sink.audio.volume = clampedVol;

    playFeedbackSound(clampedVol);

    Qt.callLater(() => {
      isSettingVolume = false;
    });
  }

  function setMuted(muted: bool) {
    if (!Pipewire.ready || (!sink?.audio && !hasWpctl)) {
      Logger.w("AudioService", "No audio sink available to set muted state");
      return;
    }

    if (hasWpctl) {
      if (wpctlSetProcess.running)
        return;

      wpctlMuted = muted;
      wpctlStateValid = true;

      const muteCmd = muted ? "1" : "0";
      wpctlSetProcess.command = ["sh", "-c", `wpctl set-mute @DEFAULT_AUDIO_SINK@ ${muteCmd}`];
      wpctlSetProcess.running = true;

      return;
    }

    if (!sink?.ready || !sink?.audio) {
      Logger.w("AudioService", "Audio sink not ready to set muted state");
      return;
    }

    sink.audio.muted = muted;
  }

  function increaseVolume() {
    if (volume >= maxVolume)
      return;

    setVolume(volume + Settings.data.audio.volumeStep / 100.0);
  }

  function decreaseVolume() {
    setVolume(volume - Settings.data.audio.volumeStep / 100.0);
  }

  Process {
    id: checkWpctlProcess
    command: ["sh", "-c", "command -v wpctl"]
  }

  Connections {
    target: checkWpctlProcess
    function onExited(exitCode) {
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
