pragma Singleton
import QtMultimedia
import QtQuick
import Quickshell
import qs.Commons

Singleton {
  id: root

  property bool hasMediaSupport: false
  property var mediaPlayerComponent: null

  function playSound(source, volume) {
    if (!hasMediaSupport)
      return;

    if (!source || source === "") {
      Logger.w("SoundService", "No audio source provided");
      return;
    }
    mediaPlayer.source = source;
    mediaPlayer.play();
  }

  Component.onCompleted: {
    try {
      const testComp = Qt.createQmlObject(`
      import QtQuick
      import QtMultimedia
      Item {}
      `, root, "MediaPlayerTest");
      if (testComp) {
        hasMediaSupport = true;
        testComp.destroy();
        Logger.d("SoundService", "Media support is available");
      }
    } catch (e) {
      Logger.e("SoundService", "Media support is not available:", e);
      return;
    }
    mediaPlayerComponent = Qt.createComponent(`${Quickshell.shellDir}/assets/qmls/MediaPlayer.qml`);
    Logger.i("SoundService", "MediaPlayer initialized");
  }

  SoundEffect {
    id: mediaPlayer
  }
}
