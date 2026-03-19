pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import qs.Commons

Singleton {
  id: root

  property PwNode sink: null
  property PwNodeAudio audio: null
  property real volume: 0
  property bool muted: false
  property bool isAvailable: sink !== null
  property bool initialized: false

  readonly property string iconName: {
    if (muted) {
     return "audio-volume-muted"
    }

    return volume >= 0.5 ? "audio-volume-high" : "audio-volume-medium"
  }

  Timer {
    interval: 500
    running: true
    onTriggered: {
      root.initialized = true
    }
  }

  Component.onCompleted: {
    root.sink = Pipewire.defaultAudioSink
    root.audio = root.sink ? root.sink.audio : null
    if (root.audio) {
      root.volume = root.audio.volume
      root.muted = root.audio.muted
    }
  }

  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink]
  }

  Connections {
    target: Pipewire

    function onDefaultAudioSinkChanged() {
      root.sink = Pipewire.defaultAudioSink
      root.audio = root.sink ? root.sink.audio : null
    }
  }

  Connections {
    target: root.audio

    function onVolumeChanged() {
      root.volume = root.audio.volume
    }

    function onMutedChanged() {
      root.muted = root.audio.muted
    }
  }

  onVolumeChanged: {
    if (!initialized || !isAvailable || typeof volume !== "number") return
    SoundService.playSound(`${Paths.sounds}/audio-volume-change.ogg`, volume);
  }

  function adjustVolume(delta) {
    if (!isAvailable) return
    Pipewire.defaultAudioSink.audio.volume = Math.max(0, Math.min(1, root.volume + delta/100));
  }
}
