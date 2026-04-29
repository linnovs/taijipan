pragma Singleton
import QtQuick
import QtMultimedia
import Quickshell
import qs.Commons

Singleton {
  id: root

  SoundEffect {
    id: volumeFeedback
    source: Settings.data.audio.volumeFeedbackSoundFile || Paths.soundPath("volume-feedback.wav")
  }

  function playSound(effect, volume = 1.0) {
    switch (effect) {
    case "volumeFeedback":
      volumeFeedback.volume = volume;
      volumeFeedback.play();
      break;
    default:
      Logger.w("SoundService", "Unknown sound effect:", effect);
    }
  }

  Component.onCompleted: {
    Logger.i("SoundService", "MediaPlayer initialized");
  }
}
