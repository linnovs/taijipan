pragma Singleton

import QtQuick
import QtMultimedia
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
  id: root

  property real volume: Pipewire.defaultAudioSink?.audio.volume ?? 0
  property bool muted: Pipewire.defaultAudioSink?.audio.muted ?? false
  property var volumeChangeSound: null

  Component {
    id: volumeChangeSoundComponent
    MediaPlayer {
      source: "../assets/sounds/audio-volume-change.mp3"
      autoPlay: false
      audioOutput: AudioOutput{}
    }
  }

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

  function createSoundPlayer() {
    if (volumeChangeSound) {
      volumeChangeSound.destroy();
      volumeChangeSound = null;
    }

    volumeChangeSound = volumeChangeSoundComponent.createObject(root);
  }

  Connections {
    target: Pipewire

    function onDefaultAudioSinkChanged() {
      Qt.callLater(root.createSoundPlayer)
    }
  }

  onVolumeChanged: {
    if (volumeChangeSound) {
      volumeChangeSound.stop();
      volumeChangeSound.play();
    }
  }

  Component.onCompleted: {
    Qt.callLater(root.createSoundPlayer)
  }
}
