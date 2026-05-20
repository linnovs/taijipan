import QtQuick
import QtQuick.Shapes
import qs.Services
import qs.Widgets
import qs.Commons

Item {
  id: root
  anchors.fill: parent

  required property var windowRoot

  readonly property color backgroundColor: Colors.mSurface

  Item {
    id: frameBackgroundContainer
    anchors.fill: parent
    layer.enabled: true
    opacity: Settings.data.ui.frame.opacity

    Shape {
      id: frameBackgroundShape
      anchors.fill: parent
      preferredRendererType: Shape.CurveRenderer
      asynchronous: true
      enabled: false

      Component.onCompleted: {
        Logger.d("PanelBackgrounds", "Frame Background shape initialized for screen:", windowRoot?.screen?.name);
      }

      FrameBackground {
        screen: root.windowRoot.screen
        fillColor: root.backgroundColor
      }
    }
  }

  Item {
    id: panelBackgroundContainer
    anchors.fill: parent
    layer.enabled: true
    opacity: Settings.data.ui.panel.opacity

    Shape {
      id: panelBackgroundShape
      anchors.fill: parent
      preferredRendererType: Shape.CurveRenderer
      asynchronous: true
      enabled: false

      Component.onCompleted: {
        Logger.d("PanelBackgrounds", "Panel Background shape initialized for screen:", windowRoot?.screen?.name);
      }

      PanelBackground {
        panel: {
          let p = PanelService.openedPanel;
          return (p && p.screen === root.windowRoot.screen) ? p : null;
        }
        backgroundColor: root.backgroundColor
      }

      PanelBackground {
        panel: {
          let p = PanelService.closingPanel;
          return (p && p.screen === root.windowRoot.screen) ? p : null;
        }
        backgroundColor: root.backgroundColor
      }
    }

    DropShadow {
      anchors.fill: parent
      source: panelBackgroundShape
    }
  }
}
