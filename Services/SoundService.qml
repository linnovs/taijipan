pragma Singleton

import QtQuick
import Quickshell
import qs.Commons

Singleton {
  id: root

  property bool hasMediaSupport: false
  property var mediaPlayerComponent: null

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

  Item {
    id: playerContainer
  }

  function playSound(source, volume) {
    if (!hasMediaSupport) return;

    if (!source || source === "") {
      Logger.w("SoundService", "No audio source provided");
      return;
    }

    if (!mediaPlayerComponent) {
      Logger.e("SoundService", "MediaPlayer component is not available");
      return;
    }

    mediaPlayerComponent.createObject(playerContainer, {
      source: source,
      volume: volume
    });
  }
}
