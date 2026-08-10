import QtQuick
import Niri
import "../themes"
import "."

// Workspace widget: the full-size minimap of the current workspace, framed by
// the mini thumbnails of the workspaces that lie immediately before (left) and
// after (right) it. Each side holds a single WorkspaceTile, or nothing when
// that neighbour index does not exist.
Item {
    id: root

    readonly property int sideGap: 20

    property string screenName: ""

    property var _rows: ({})
    property var leftTiles: []
    property var rightTiles: []
    property var curMeta: null
    property bool curEmpty: false

    implicitWidth: childrenRect.width
    implicitHeight: 40
    width: implicitWidth
    height: implicitHeight

    Niri {
        id: niri

        Component.onCompleted: connect()
    }

    Connections {
        target: niri
        function onConnected() { root._refresh() }
        function onFocusedWindowChanged() { root._refresh() }
    }
    Connections {
        target: niri.windows
        function onCountChanged() { root._refresh() }
    }
    Connections {
        target: niri.workspaces
        function onCountChanged() { root._refresh() }
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
        root._rows[id] = ws
        root._refresh()
    }
    function _del(id) {
        delete root._rows[id]
        root._refresh()
    }

    function currentIndex() {
        const n = niri.workspaces.count
        for (let i = 0; i < n; i++) {
            const ws = niri.workspaces.get(i)
            if (root.screenName !== "" && ws.output !== root.screenName) continue
            if (ws.isFocused) return ws.index
        }
        return 1
    }

    function _refresh() {
        // Rebuild the workspace -> window count map.
        const counts = {}
        for (const id in root._rows) {
            const w = root._rows[id]
            counts[w] = (counts[w] || 0) + 1
        }

        const cur = root.currentIndex()
        const n = niri.workspaces.count

        const mk = (ws, c) => ({
            id: ws.id, index: ws.index, name: ws.name, count: c,
            isActive: ws.isActive, isFocused: ws.isFocused, isUrgent: ws.isUrgent
        })

        const left = []
        const right = []
        let curWs = null
        for (let i = 0; i < n; i++) {
            const ws = niri.workspaces.get(i)
            if (root.screenName !== "" && ws.output !== root.screenName) continue
            const c = counts[ws.id] || 0

            if (ws.index === cur) { curWs = ws; continue }

            const isOpen = ws.isActive || c > 0
            if (!isOpen) continue

            const item = mk(ws, c)
            if (ws.index < cur) left.push(item)
            else right.push(item)
        }

        left.sort((a, b) => a.index - b.index)
        right.sort((a, b) => a.index - b.index)

        root.leftTiles = left
        root.rightTiles = right

        root.curEmpty = !!curWs && (counts[curWs.id] || 0) === 0
        root.curMeta = root.curEmpty ? mk(curWs, 0) : null
    }

    Row {
        spacing: 6
        height: 40

        Repeater {
            model: root.leftTiles
            delegate: Item {
                width: tile.tileW
                height: 40
                WorkspaceTile {
                    id: tile
                    anchors.centerIn: parent
                    meta: modelData
                }
            }
        }

        Item {
            width: root.curEmpty ? holeTile.tileW : minimap.width
            height: 40

            WorkspaceMinimap {
                id: minimap
                anchors.centerIn: parent
                visible: !root.curEmpty
                screenName: root.screenName
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
                height: 40
                WorkspaceTile {
                    id: rtile
                    anchors.centerIn: parent
                    meta: modelData
                }
            }
        }
    }
}