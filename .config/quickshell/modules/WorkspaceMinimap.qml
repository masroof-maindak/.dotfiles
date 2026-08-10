import QtQuick
import Niri
import "../themes"

Item {
    id: root

    readonly property int mapHeight: 26
    readonly property int maxWidth: 520
    readonly property int minGap: 2
    readonly property int gap: 5

    property string screenName: ""
    property var rects: []
    property int hoveredId: -1
    property string hoveredTitle: ""

    Niri {
        id: niri
        Component.onCompleted: connect()
        onConnected: root._recompute()
        onFocusedWindowChanged: root._recompute()
    }

    // Live per-window snapshot, keyed by window id. Kept in lockstep with the
    // window model via delegate role bindings, so no plugin changes are needed.
    property var _rows: ({})

    function _registerRow(item) {
        root._rows[item._k] = item;
        root._recompute();
    }

    function _unregisterRow(k) {
        delete root._rows[k];
        root._recompute();
    }

    function _bump() {
        root._recompute();
    }

    function _wsOutput(wsId) {
        const idx = niri.workspaces.indexOfId(wsId);
        if (idx === -1)
            return "";
        return niri.workspaces.get(idx).output;
    }

    function currentWorkspaceId() {
        const count = niri.workspaces.count;
        for (let i = 0; i < count; i++) {
            const ws = niri.workspaces.get(i);
            if (root.screenName !== "" && ws.output !== root.screenName)
                continue;
            if (ws.isFocused)
                return ws.id;
        }
        const fw = niri.focusedWindow;
        if (fw && (root.screenName === "" || root._wsOutput(fw.workspaceId) === root.screenName))
            return fw.workspaceId;
        for (const k in root._rows) {
            const wsId = root._rows[k]._ws;
            if (root.screenName === "" || root._wsOutput(wsId) === root.screenName)
                return wsId;
        }
        return 0;
    }

    function _recompute() {
        const target = currentWorkspaceId();
        const keys = Object.keys(root._rows);
        if (!target || keys.length === 0) {
            root.rects = [];
            root.visible = false;
            return;
        }

        // Group tiled windows of the target workspace by column.
        const cols = {};
        for (let i = 0; i < keys.length; i++) {
            const r = root._rows[keys[i]];
            if (r._ws !== target || r._fl)
                continue;
            const c = r._c;
            let col = cols[c];
            if (!col) {
                col = cols[c] = {
                    width: 0,
                    items: []
                };
            }
            if (r._w > col.width)
                col.width = r._w;
            col.items.push(r);
        }

        const order = Object.keys(cols).map(Number).sort((a, b) => a - b);
        if (order.length === 0) {
            root.rects = [];
            root.visible = false;
            return;
        }

        // Absolute column offsets = sum of preceding column widths.
        // When the map is heavily compressed, enforce a minimum *visual* gap
        // between silhouettes so windows never read as touching.
        const wsExtentH = order.reduce((acc, c) => {
            const col = cols[c];
            col.items.sort((a, b) => a._r - b._r);
            return Math.max(acc, col.items.reduce((y, r) => y + r._h, 0));
        }, 0);

        if (wsExtentH <= 0) {
            root.rects = [];
            root.visible = false;
            return;
        }

        const compressed = wsExtentH > root.mapHeight;
        const nVGaps = order.reduce((n, c) => n + Math.max(0, cols[c].items.length - 1), 0);
        const vGap = compressed ? Math.min(root.minGap, (root.mapHeight * 0.5) / Math.max(1, nVGaps)) : 0;
        const hGap = compressed ? root.minGap : 0;

        // Full workspace height maps to the bar height. Min gaps are added on
        // top of the layout, so columns without internal gaps stay at 100%.
        const s = root.mapHeight / wsExtentH;

        const colX = {};
        let cx = 0;
        for (let i = 0; i < order.length; i++) {
            colX[order[i]] = cx;
            cx += cols[order[i]].width * s + hGap;
        }

        // Layout rows in scaled pixels. Columns with stacked tiles get their own
        // vertical scale so rows + min gaps just fit inside the column's
        // height budget; columns without internal gaps stay at full size.
        const out = [];
        let totalW = 0;
        for (let i = 0; i < order.length; i++) {
            const ord = order[i];
            const items = cols[ord].items;
            let colY = s;
            let cy = 0;
            const gaps = items.length - 1;
            if (gaps > 0 && compressed) {
                const rawReal = items.reduce((y, r) => y + r._h, 0);
                const room = rawReal * s - gaps * vGap;
                if (room > 0)
                    colY = room / rawReal;
            }
            for (let j = 0; j < items.length; j++) {
                const r = items[j];
                out.push({
                    id: r._k,
                    wx: colX[ord] + (r._w - cols[ord].width) * s * 0.5,
                    wy: cy,
                    ww: r._w * s,
                    wh: r._h * colY,
                    focused: r._f,
                    title: r._title,
                    cx: ord
                });
                cy += r._h * colY + vGap;
            }
            totalW = Math.max(totalW, colX[ord] + cols[ord].width * s);
        }

        const viewW = Math.max(1, Math.min(totalW, root.maxWidth));

        // If the map is wider than the bar slot, pan to keep the focused tile visible.
        let trans = 0;
        if (totalW > viewW) {
            const f = out.find(o => o.focused);
            const focusCx = f ? f.wx + f.ww / 2 : viewW / 2;
            trans = Math.max(0, Math.min(totalW - viewW, focusCx - viewW / 2));
        }

        root.rects = out.map(o => ({
                    id: o.id,
                    x: o.wx - trans,
                    y: o.wy,
                    w: Math.max(1, o.ww),
                    h: Math.max(1, o.wh),
                    focused: o.focused,
                    title: o.title,
                    cx: o.cx
                }));

        root.width = Math.round(viewW) + root.gap * 2;
        root.height = root.mapHeight + root.gap * 2;
        root.visible = true;
    }

    // Card backdrop
    Rectangle {
        id: card
        anchors.fill: parent
        radius: 4
        color: Theme.palette.minimapBg
    }

    // Window silhouettes
    Item {
        id: mapArea
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            leftMargin: root.gap
            rightMargin: root.gap
            topMargin: root.gap
            bottomMargin: root.gap
        }

        Repeater {
            model: root.rects

            delegate: Rectangle {
                id: tile
                x: modelData.x
                y: modelData.y
                width: modelData.w
                height: modelData.h
                radius: Math.max(1, Math.min(2, Math.round(height / 4)))
                color: modelData.focused ? Theme.palette.workspaceActive : Theme.palette.minimapWindow
                opacity: modelData.focused ? 1 : 0.85

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: niri.focusWindow(modelData.id)
                    onEntered: {
                        root.hoveredId = modelData.id;
                        root.hoveredTitle = modelData.title;
                    }
                    onExited: {
                        if (root.hoveredId === modelData.id)
                            root.hoveredId = -1;
                    }
                }
            }
        }
    }

    // Hover tooltip (sits just below the bar)
    Rectangle {
        id: tooltip
        visible: root.hoveredId !== -1
        z: 20
        width: tipText.implicitWidth + 14
        height: tipText.implicitHeight + 6
        radius: 3
        color: Theme.palette.barBg
        border.color: Theme.palette.minimapBg
        border.width: 1

        x: {
            const hi = root.hoveredId;
            if (hi === -1)
                return 0;
            let idx = -1;
            for (let i = 0; i < root.rects.length; i++) {
                if (root.rects[i].id === hi) {
                    idx = i;
                    break;
                }
            }
            if (idx === -1)
                return 0;
            const r = root.rects[idx];
            return Math.max(0, Math.min(root.width - width, r.x + r.w / 2 - width / 2));
        }
        y: root.height + 3

        Text {
            id: tipText
            anchors.centerIn: parent
            text: root.hoveredTitle
            color: Theme.palette.text
            font.family: Theme.palette.fontFamily
            font.pixelSize: 10
        }
    }

    // Snapshot collector: one delegate per window in the niri model.
    Repeater {
        id: collector
        model: niri.windows

        delegate: Item {
            id: row
            width: 0
            height: 0

            readonly property int _k: model.id
            readonly property int _c: model.columnIndex
            readonly property int _r: model.tileIndex
            readonly property real _w: model.tileWidth
            readonly property real _h: model.tileHeight
            readonly property int _ws: model.workspaceId
            readonly property bool _fl: model.isFloating
            readonly property bool _f: model.isFocused
            readonly property string _title: model.title

            on_KChanged: root._bump()
            on_CChanged: root._bump()
            on_RChanged: root._bump()
            on_WChanged: root._bump()
            on_HChanged: root._bump()
            on_WsChanged: root._bump()
            on_FlChanged: root._bump()
            on_FChanged: root._bump()
            on_TitleChanged: root._bump()

            Component.onCompleted: root._registerRow(this)
            Component.onDestruction: root._unregisterRow(_k)
        }
    }
}
