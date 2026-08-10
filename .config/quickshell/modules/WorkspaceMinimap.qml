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
    // Logical tiled-region height of the output this minimap is shown on: the
    // output's height minus the space reserved by the bar. niri tiles windows
    // to exactly this height, while each screen reports it for itself, so
    // windows fill the map edge-to-edge here without cross-screen drift.
    property real screenH: 0
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
    // Height of the fixed tiled region for this output, in logical pixels.
    // Constant per output, so the tallest column extent seen is cached and the
    // same scale is always applied to the workspaces of this output.
    property real regionH: 0

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

        // Sort each column's windows from top to bottom. The tallest single tile
        // is a stable reference for the tiled-region height: a tile never
        // exceeds it even mid-animation or when tabs overlap, so caching it
        // can't be inflated by momentary column sums.
        let maxSingle = 0;
        for (const c of order) {
            cols[c].items.sort((a, b) => a._r - b._r);
            for (const r of cols[c].items)
                maxSingle = Math.max(maxSingle, r._h);
        }
        if (maxSingle <= 0) {
            root.rects = [];
            root.visible = false;
            return;
        }

        // Tile sizes are real logical pixels and every default column of the
        // workspace sums to the same fixed tiled-region height. Prefer the
        // screen's own height as that reference: it is exact and can't be
        // inflated by tiles mid-animation or by windows of the shared workspace
        // that physically sit on a taller monitor. Falling back to a measured
        // cache keeps a self-contained default for unusual setups.
        if (root.screenH > 0)
            root.regionH = root.screenH;
        else
            root.regionH = Math.max(root.regionH, maxSingle);
        const s = root.mapHeight / Math.max(1, root.regionH);

        // Minimum internal gap between silhouettes: 2px between stacked tiles
        // in a column and between neighbouring columns.
        const hGap = root.minGap;

        const colX = {};
        let cx = 0;
        for (let i = 0; i < order.length; i++) {
            colX[order[i]] = cx;
            cx += cols[order[i]].width * s + hGap;
        }

        // Stacked tiles are laid out top-to-bottom at their real height, with a
        // minimum gap between them. If a column overflows the map height once
        // the gaps are added, scale the tiles back so the gap is preserved.
        const out = [];
        let totalW = 0;
        for (let i = 0; i < order.length; i++) {
            const ord = order[i];
            const items = cols[ord].items;
            const gaps = items.length - 1;

            // A column whose tiles all sit at ~full region height is tabbed:
            // the tiles overlap, so only the visible (focused) tab is drawn.
            const tabbed = items.length > 1 &&
                items.every(r => r._h >= root.regionH * 0.8);
            if (tabbed) {
                const r = items.find(x => x._f) || items[0];
                out.push({
                    id: r._k,
                    wx: colX[ord] + (r._w - cols[ord].width) * s * 0.5,
                    wy: 0,
                    ww: r._w * s,
                    wh: r._h * s,
                    focused: r._f,
                    title: r._title,
                    cx: ord
                });
                totalW = Math.max(totalW, colX[ord] + cols[ord].width * s);
                continue;
            }

            const rawH = items.reduce((y, r) => y + r._h, 0) * s;
            // Columns are top-aligned to the tiled region, matching niri.
            let cy = 0;
            let vSpacing = 0;
            let colY = 1;
            if (items.length > 1) {
                vSpacing = Math.min(root.minGap, rawH / (gaps + 1));
                if (rawH > 0)
                    colY = (rawH - gaps * vSpacing) / rawH;
            }
            for (let j = 0; j < items.length; j++) {
                const r = items[j];
                out.push({
                    id: r._k,
                    wx: colX[ord] + (r._w - cols[ord].width) * s * 0.5,
                    wy: cy,
                    ww: r._w * s,
                    wh: r._h * s * colY,
                    focused: r._f,
                    title: r._title,
                    cx: ord
                });
                cy += r._h * s * colY + vSpacing;
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
                    h: Math.max(1, Math.min(o.wh, root.mapHeight)),
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
