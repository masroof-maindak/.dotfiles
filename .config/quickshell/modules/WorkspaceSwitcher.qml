import QtQuick
import Niri
import "../themes"
import "."
import "utils.js" as Utils

// Workspace widget: the full-size minimap of the current workspace, framed by
// the mini thumbnails of the open workspaces before (left) and after (right)
// it. The centre shows a plain tile when the current workspace has no windows
// or the output lacks focus.
Item {
    id: root

    readonly property int barH: 40

    property string screenName: ""
    property real screenH: 0

    property var _rows: ({})
    property var leftTiles: []
    property var rightTiles: []
    property var curMeta: null
    property bool curEmpty: false

    implicitWidth: childrenRect.width
    implicitHeight: root.barH

    Niri {
        id: niri

        Component.onCompleted: connect()
    }

    Connections {
        target: niri
        function onConnected() {
            root._refresh();
        }
        function onFocusedWindowChanged() {
            root._refresh();
        }
    }
    Connections {
        target: niri.windows
        function onCountChanged() {
            root._refresh();
        }
    }
    Connections {
        target: niri.workspaces
        function onCountChanged() {
            root._refresh();
        }
        function onDataChanged() {
            root._refresh();
        }
    }

    // Track which workspace each window lives on (no plugin changes needed).
    Repeater {
        model: niri.windows
        delegate: Item {
            readonly property int _wid: model.id
            readonly property int _ws: model.workspaceId
            on_WsChanged: root._set(_wid, _ws)
            Component.onCompleted: root._set(_wid, _ws)
            Component.onDestruction: root._del(_wid)
        }
    }

    function _set(id, ws) {
        root._rows[id] = ws;
        root._refresh();
    }
    function _del(id) {
        delete root._rows[id];
        root._refresh();
    }

    // True while focus lives on this output: either a workspace of this screen
    // is focused, or the focused window still points here (covers the race
    // where the workspace model hasn't caught up with a focus change yet).
    function _screenFocused() {
        const count = niri.workspaces.count;
        for (let i = 0; i < count; i++) {
            const ws = niri.workspaces.get(i);
            if (!Utils.onScreen(ws, root.screenName))
                continue;
            if (ws.isFocused)
                return true;
        }
        const fw = niri.focusedWindow;
        if (fw && (root.screenName === "" || Utils.wsOutput(niri.workspaces, fw.workspaceId) === root.screenName))
            return true;
        return false;
    }

    function currentIndex() {
        const n = niri.workspaces.count;
        for (let i = 0; i < n; i++) {
            const ws = niri.workspaces.get(i);
            if (!Utils.onScreen(ws, root.screenName))
                continue;
            if (ws.isFocused)
                return ws.index;
        }
        // Unfocused output: the workspace actually shown on it is `isActive`
        // but not `isFocused`. Use that one so every workspace of this output
        // stays visible instead of arbitrarily picking the first.
        for (let i = 0; i < n; i++) {
            const ws = niri.workspaces.get(i);
            if (!Utils.onScreen(ws, root.screenName))
                continue;
            if (ws.isActive)
                return ws.index;
        }
        return 1;
    }

    function _refresh() {
        // Rebuild the workspace -> window count map.
        const counts = {};
        for (const id in root._rows) {
            const w = root._rows[id];
            counts[w] = (counts[w] || 0) + 1;
        }

        const cur = root.currentIndex();
        const n = niri.workspaces.count;

        const mk = (ws, c) => ({
                    id: ws.id,
                    index: ws.index,
                    name: ws.name,
                    count: c,
                    isActive: ws.isActive,
                    isFocused: ws.isFocused,
                    isUrgent: ws.isUrgent
                });

        const left = [];
        const right = [];
        let curWs = null;
        for (let i = 0; i < n; i++) {
            const ws = niri.workspaces.get(i);
            if (!Utils.onScreen(ws, root.screenName))
                continue;
            const c = counts[ws.id] || 0;

            if (ws.index === cur) {
                curWs = ws;
                continue;
            }

            const isOpen = ws.isActive || c > 0;
            if (!isOpen)
                continue;
            const item = mk(ws, c);
            if (ws.index < cur)
                left.push(item);
            else
                right.push(item);
        }

        left.sort((a, b) => a.index - b.index);
        right.sort((a, b) => a.index - b.index);

        root.leftTiles = left;
        root.rightTiles = right;

        const focused = root._screenFocused();
        const curCount = curWs ? (counts[curWs.id] || 0) : 0;
        // The centre slot shows the window minimap only while this output has
        // focus and the current workspace has windows; otherwise it shows a
        // plain tile so every workspace of this output stays visible. While
        // unfocused the tile keeps its real window count.
        root.curEmpty = !!curWs && (!focused || curCount === 0);
        root.curMeta = root.curEmpty ? mk(curWs, focused ? 0 : curCount) : null;
    }

    Row {
        spacing: 6
        height: root.barH

        Repeater {
            model: root.leftTiles
            delegate: Item {
                width: tile.tileW
                height: root.barH
                WorkspaceTile {
                    id: tile
                    anchors.centerIn: parent
                    meta: modelData
                }
            }
        }

        Item {
            width: root.curEmpty ? holeTile.tileW : minimap.width
            height: root.barH

            WorkspaceMinimap {
                id: minimap
                anchors.centerIn: parent
                visible: !root.curEmpty
                screenName: root.screenName
                screenH: root.screenH
            }

            WorkspaceTile {
                id: holeTile
                visible: root.curEmpty
                anchors.centerIn: parent
                meta: root.curMeta
            }
        }

        Repeater {
            model: root.rightTiles
            delegate: Item {
                width: rtile.tileW
                height: root.barH
                WorkspaceTile {
                    id: rtile
                    anchors.centerIn: parent
                    meta: modelData
                }
            }
        }
    }
}
