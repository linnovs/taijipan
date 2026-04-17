import QtMultimedia
import QtQuick

MediaPlayer {
  id: root

  property real volume: Math.max(0, Math.min(1, volume))

  source: source
  Component.onCompleted: {
    play();
  }
  onPlaybackStateChanged: {
    if (!playing)
      destroy();
  }

  audioOutput: AudioOutput {
    volume: root.volume
  }
}
