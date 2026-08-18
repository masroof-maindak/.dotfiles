import QtQuick
import Quickshell
import Niri
import "../themes"
import "utils.js" as Utils

Item {
    id: root

    readonly property int mapHeight: 26
    readonly property int maxWidth: 520
    readonly property int minGap: 2
    readonly property int gap: 5

    property string screenName: ""
    // Tiled-region height of this output (its height minus the bar), so niri's
    // windows fill the map edge-to-edge without cross-screen drift.
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
    // Cached tiled-region height for scaling when screenH is unavailable.
    property real regionH: 0

    function _registerRow(item) {
        root._rows[item._k] = item;
        root._recompute();
    }

    function _unregisterRow(k) {
        delete root._rows[k];
        root._recompute();
    }

    function _hide() {
        root.rects = [];
        root.width = 0;
        root.height = 0;
        root.visible = false;
    }

    function currentWorkspaceId() {
        const count = niri.workspaces.count;
        for (let i = 0; i < count; i++) {
            const ws = niri.workspaces.get(i);
            if (!Utils.onScreen(ws, root.screenName))
                continue;
            if (ws.isFocused)
                return ws.id;
        }
        // Focus lives on another output: show nothing here. The focused
        // window fallback only covers the race where the workspace model
        // hasn't caught up yet; if it isn't on this screen we hide.
        const fw = niri.focusedWindow;
        if (fw && (root.screenName === "" || Utils.wsOutput(niri.workspaces, fw.workspaceId) === root.screenName))
            return fw.workspaceId;
        return 0;
    }

    function _recompute() {
        const target = currentWorkspaceId();
        const keys = Object.keys(root._rows);
        if (!target || keys.length === 0) {
            root._hide();
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
            root._hide();
            return;
        }

        // Sort each column top to bottom; the tallest single tile is the stable
        // reference for the tiled-region height (never inflated by column sums).
        let maxSingle = 0;
        for (const c of order) {
            cols[c].items.sort((a, b) => a._r - b._r);
            for (const r of cols[c].items)
                maxSingle = Math.max(maxSingle, r._h);
        }
        if (maxSingle <= 0) {
            root._hide();
            return;
        }

        // Prefer the screen's own height as the tiled-region reference: it is
        // exact and immune to mid-animation tiles or shared-workspace windows on
        // a taller monitor. The measured cache is the fallback.
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

        // Stack tiles top-to-bottom at real height; if a column overflows the
        // map with gaps added, scale tiles back to preserve the gap.
        const out = [];
        let totalW = 0;
        for (let i = 0; i < order.length; i++) {
            const ord = order[i];
            const items = cols[ord].items;
            const gaps = items.length - 1;

            // A column whose tiles all sit at ~full region height is tabbed:
            // the tiles overlap, so only the visible (focused) tab is drawn.
            const tabbed = items.length > 1 && items.every(r => r._h >= root.regionH * 0.8);
            if (tabbed) {
                const r = items.find(x => x._f) || items[0];
                out.push({
                    id: r._k,
                    wx: colX[ord] + (r._w - cols[ord].width) * s * 0.5,
                    wy: 0,
                    ww: r._w * s,
                    wh: r._h * s,
                    focused: r._f,
                    title: r._title
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
                    title: r._title
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
                    title: o.title
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

    // Hover tooltip: a separate popup window anchored below the map, so it
    // isn't clipped to the height of the bar.
    PopupWindow {
        id: tooltip
        visible: root.hoveredId !== -1
        color: Theme.palette.barBg
        anchor.item: root
        anchor.rect.x: {
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
            return Math.max(0, Math.min(root.width - tooltip.implicitWidth, r.x + r.w / 2 - tooltip.implicitWidth / 2));
        }
        anchor.rect.y: root.height + 3
        implicitWidth: tipText.implicitWidth + 14
        implicitHeight: tipText.implicitHeight + 6

        Rectangle {
            anchors.fill: parent
            radius: 3
            color: Theme.palette.barBg
            border.color: Theme.palette.minimapBg
            border.width: 1

            Text {
                id: tipText
                anchors.centerIn: parent
                text: root.hoveredTitle
                color: Theme.palette.text
                font.family: Theme.palette.fontFamily
                font.pixelSize: 12
            }
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

            on_KChanged: root._recompute()
            on_CChanged: root._recompute()
            on_RChanged: root._recompute()
            on_WChanged: root._recompute()
            on_HChanged: root._recompute()
            on_WsChanged: root._recompute()
            on_FlChanged: root._recompute()
            on_FChanged: root._recompute()
            on_TitleChanged: root._recompute()

            Component.onCompleted: root._registerRow(this)
            Component.onDestruction: root._unregisterRow(_k)
        }
    }
}
