pragma ComponentBehavior: Bound

pragma Singleton

import QtQuick
import QtMultimedia
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
  id: root

  property real volume: Pipewire.defaultAudioSink?.audio.volume ?? 0
  property bool muted: Pipewire.defaultAudioSink?.audio.muted ?? false
  property var mediaDevices: null
  property var mediaDevicesConnections: null
  property var volumeChangeSound: null

  Component {
    id: mediaDevicesComponent
    MediaDevices {}
  }

  Component {
    id: mediaDevicesConnectionsComponent
    Connections {
      property var mediaDevices: null
      target: mediaDevices
      function onDefaultAudioOutputChanged() {
        root.createSoundPlayer()
      }
    }
  }

  Component {
    id: audioOutputComponent
    AudioOutput {}
  }

  Component {
    id: volumeChangeSoundComponent
    MediaPlayer {
      source: "../assets/sounds/audio-volume-change.ogg"
      autoPlay: false
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
    if (mediaDevices) {
      mediaDevices.destroy();
      mediaDevices = null;
    }

    if (mediaDevicesConnections) {
      mediaDevicesConnections.destroy();
      mediaDevicesConnections = null;
    }

    if (volumeChangeSound) {
      volumeChangeSound.destroy();
      volumeChangeSound = null;
    }

    mediaDevices = mediaDevicesComponent.createObject(root);
    mediaDevicesConnections = mediaDevicesConnectionsComponent.createObject(root, { mediaDevices: mediaDevices });
    volumeChangeSound = volumeChangeSoundComponent.createObject(root);
    volumeChangeSound.audioOutput = audioOutputComponent.createObject(root, { "output": mediaDevices.defaultAudioOutput });
  }

  Connections {
    target: Pipewire

    function onDefaultAudioSinkChanged() {
      root.createSoundPlayer()
    }
  }

  onVolumeChanged: {
    if (volumeChangeSound) {
      volumeChangeSound.stop();
      volumeChangeSound.play();
    }
  }

  Component.onCompleted: {
    root.createSoundPlayer()
  }

  function adjustVolume(delta) {
    Pipewire.defaultAudioSink.audio.volume = Math.max(0, Math.min(1, root.volume + delta/100));
  }
}
