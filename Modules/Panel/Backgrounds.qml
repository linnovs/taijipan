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
    id: barBackgroundContainer
    anchors.fill: parent
    layer.enabled: true
    opacity: Settings.data.ui.bar.opacity

    Shape {
      id: barBackgroundShape
      anchors.fill: parent
      preferredRendererType: Shape.CurveRenderer
      asynchronous: true
      enabled: false

      Component.onCompleted: {
        Logger.d("PanelBackgrounds", "Bar Background shape initialized for screen:", windowRoot?.screen?.name);
      }

      FrameBackground {
        screen: root.windowRoot.screen
        fillColor: root.backgroundColor
      }

      BarBackground {
        section: "left"
        screen: root.windowRoot.screen
        sectionWidth: root.bar.leftBarWidth
        fillColor: root.backgroundColor
      }

      BarBackground {
        section: "center"
        screen: root.windowRoot.screen
        sectionWidth: root.bar.centerBarWidth
        fillColor: root.backgroundColor
      }

      BarBackground {
        section: "right"
        screen: root.windowRoot.screen
        sectionWidth: root.bar.rightBarWidth
        fillColor: root.backgroundColor
      }
    }

    DropShadow {
      anchors.fill: parent
      source: barBackgroundShape
      autoPaddingEnabled: true
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
