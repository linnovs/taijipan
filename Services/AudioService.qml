pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
  id: root

  property real volume: Pipewire.defaultAudioSink?.audio.volume ?? 0
  property bool muted: Pipewire.defaultAudioSink?.audio.muted ?? false

  readonly property string iconName: {
    if (Pipewire.defaultAudioSink.audio.muted) {
     return "audio-volume-muted"
    }

    return volume >= 0.5 ? "audio-volume-high" : "audio-volume-medium"
  }

  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink]
  }

  Binding {
    root.volume: Pipewire.defaultAudioSink.audio.volume
    root.muted: Pipewire.defaultAudioSink.audio.muted
  }
}
