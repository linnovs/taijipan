import QtQuick
import qs.Widgets
import qs.Services
import qs.Commons

BaseBarWidget {
  id: root

  property ListModel currentWorkspaces: ListModel {}

  property int pillSpacing: Theme.spacing * 2
  property int pillHeight: root.implicitHeight * 0.45
  property int inactiveWidth: pillHeight
  property int activeWidth: root.implicitHeight * 0.85
  property int currentIdx: -1

  widgetSource: Row {
    spacing: pillSpacing

    Repeater {
      model: currentWorkspaces
      delegate: WorkspacePill {}
    }
  }

  property int scrollDirection: 0
  Timer {
    id: scrollDebounce
    interval: Theme.timerDebounce
    onTriggered: {
      if (scrollDirection === 0 || root.currentIdx === -1)
        return;

      const nextIdx = (root.currentIdx + root.scrollDirection + root.currentWorkspaces.count) % root.currentWorkspaces.count;
      const ws = root.currentWorkspaces.get(nextIdx);

      if (ws)
        NiriService.focusWorkspace(ws.id);
      scrollDirection = 0;
    }
  }

  MouseArea {
    id: mouseArea
    x: root.widgetRawSize.x
    y: root.widgetRawSize.y
    width: root.widgetRawSize.width
    height: root.widgetRawSize.height
    acceptedButtons: Qt.NoButton
    onWheel: event => {
      if (root.currentIdx === -1)
        return;

      scrollDirection = event.angleDelta.y > 0 ? -1 : 1;
      event.accepted = true;
      scrollDebounce.restart();
    }
  }

  function syncWorkspaces() {
    if (screen === null)
      return;

    const workspaceList = [];
    for (let i = 0; i < NiriService.workspaces.count; i++) {
      const ws = NiriService.workspaces.get(i);

      if (ws.output.toLowerCase() !== root.screen.name.toLowerCase())
        continue;

      workspaceList.push({
        id: ws.id,
        idx: ws.idx,
        name: ws.name,
        output: ws.output,
        isFocused: ws.isFocused,
        isActive: ws.isActive,
        isUrgent: ws.isUrgent,
        isOccupied: ws.isOccupied
      });
    }

    let i = 0;
    while (i < currentWorkspaces.count || i < workspaceList.length) {
      if (i >= currentWorkspaces.count) {
        currentWorkspaces.append(workspaceList[i]);
        i++;
        continue;
      }

      let existing = currentWorkspaces.get(i);
      let updated = workspaceList.find(w => w.id === existing.id);

      if (!updated) {
        currentWorkspaces.remove(i);
      } else {
        currentWorkspaces.set(i, updated);
        i++;
      }
    }

    for (let i = 0; i < currentWorkspaces.count; i++) {
      if (currentWorkspaces.get(i).isActive) {
        currentIdx = i;
        return;
      }
    }
  }

  Timer {
    id: workspaceSyncTimer
    interval: Theme.timerDebounce
    onTriggered: Qt.callLater(syncWorkspaces)
  }

  Component.onCompleted: syncWorkspaces()

  Connections {
    target: NiriService
    function onWorkspacesUpdated() {
      workspaceSyncTimer.restart();
    }
  }
}
