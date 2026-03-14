import QtQuick
import QtMultimedia
import qs.Commons

MediaPlayer {
  id: root

  property real volume: Math.max(0, Math.min(1, volume))

  source: source
  audioOutput: AudioOutput {
    volume: root.volume
  }

  Component.onCompleted: {
    play()
  }

  onPlaybackStateChanged: {
    if (!playing) {
      Logger.d("MediaPlayer", "Audio playback finished, destroying player");
      destroy();
    }
  }
}
