import QtQuick
import QtQuick.Shapes
import qs.Services
import qs.Widgets
import qs.Commons

Item {
  id: root
  anchors.fill: parent

  property var bar

  required property var windowRoot

  readonly property color backgroundColor: Colors.mSurface

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
      }

      PanelBackground {
        panel: {
          let p = PanelService.closingPanel;
          return (p && p.screen === root.windowRoot.screen) ? p : null;
        }
      }
    }

    DropShadow {
      anchors.fill: parent
      source: panelBackgroundShape
    }
  }
}
