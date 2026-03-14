pragma Singleton

import QtQuick
import Quickshell
import qs.Commons

Singleton {
  id: root

  property bool hasMediaSupport: false
  property var mediaPlayerComponent: null

  Item {
    id: playerContainer
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
      }
    } catch (e) {
      Logger.e("AudioFeedback", "Media support is not available:", e);
      return;
    }

    mediaPlayerComponent = Qt.createComponent(`${Quickshell.shellDir}/assets/qmls/MediaPlayer.qml`);
  }

  function playSound(source, volume) {
    if (!hasMediaSupport) return;

    if (!source || source === "") {
      Logger.w("AudioFeedback", "No audio source provided");
      return;
    }

    if (!mediaPlayerComponent) {
      Logger.e("AudioFeedback", "MediaPlayer component is not available");
      return;
    }

    mediaPlayerComponent.createObject(playerContainer, {
      source: source,
      volume: volume
    });
  }
}
