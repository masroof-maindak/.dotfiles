import QtQuick
import Niri
import "../themes"

// Mini workspace "squircle". A uniform-sized rounded-square thumbnail for an
// open workspace, fed a plain object through `meta`. Window count is shown as
// a centred row of fixed-size slots (never squished into the tile).
Item {
    id: root

    property var meta: null

    readonly property int tileH: 39
    readonly property int radius: 15
    readonly property int slotGap: 3
    readonly property int cellSize: 14

    readonly property bool _hasMeta: !!root.meta
    readonly property bool _focused: root._hasMeta && root.meta.isFocused
    readonly property int _count: root._hasMeta ? root.meta.count : 0

    readonly property color curColor: root._hasMeta ? (root.meta.isUrgent ? Theme.palette.workspaceUrgent : Theme.palette.workspaceColors[(root.meta.index - 1) % Theme.palette.workspaceColors.length]) : Theme.palette.workspaceColors[0]

    // Grid metrics for the window squircles: a single centered row. Squircles
    // stay fixed size; the tile widens to fit, never shrinking them.
    readonly property int _cols: root._hasMeta ? Math.max(1, root.meta.count) : 0
    readonly property int _rows: root._hasMeta ? 1 : 0
    readonly property real _cell: root.cellSize
    readonly property real _gridW: root._cols * root._cell + root.slotGap * (root._cols - 1)
    readonly property real _gridH: root._rows * root._cell + root.slotGap * (root._rows - 1)
    readonly property int tileW: Math.max(root.tileH, root._gridW + 6)

    width: root.tileW
    height: root.tileH

    Niri {
        id: niri
        Component.onCompleted: connect()
    }

    // Squircle body
    Rectangle {
        anchors.fill: parent
        radius: root.radius
        color: root._count === 0 ? "transparent" : (root._focused ? Qt.rgba(1, 1, 1, 0.06) : (root._hasMeta && root.meta.isActive ? Qt.rgba(1, 1, 1, 0.03) : "transparent"))
        border.width: 1
        border.color: root._count === 0 ? "transparent" : (root._focused ? Theme.palette.text : (root._hasMeta && root.meta.isActive ? root.curColor : "transparent"))
        opacity: root._count === 0 ? 1 : (root._focused ? 1 : (root._hasMeta && root.meta.isActive ? 0.7 : 1))
    }

    // Focused squircle gets a dotted outline (only when it has windows).
    Canvas {
        anchors.fill: parent
        visible: root._focused && root._count > 0
        antialiasing: true
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        onPaint: {
            const ctx = getContext("2d");
            ctx.reset();
            const w = width, h = height;
            const r = root.radius - 0.5;
            ctx.lineWidth = 1.2;
            ctx.strokeStyle = Theme.palette.accent;
            ctx.setLineDash([1, 2]);
            ctx.lineCap = "round";
            ctx.beginPath();
            ctx.moveTo(r, 0);
            ctx.lineTo(w - r, 0);
            ctx.arcTo(w, 0, w, r, r);
            ctx.lineTo(w, h - r);
            ctx.arcTo(w, h, w - r, h, r);
            ctx.lineTo(r, h);
            ctx.arcTo(0, h, 0, h - r, r);
            ctx.lineTo(0, r);
            ctx.arcTo(0, 0, r, 0, r);
            ctx.closePath();
            ctx.stroke();
        }
    }

    // Mini window squircles - one per window, all shown, laid out in a
    // centered grid at a fixed cell size (never squished).
    Repeater {
        model: root._count
        delegate: Rectangle {
            width: root._cell
            height: root._cell
            radius: root._cell * 0.2
            color: root._focused ? Theme.palette.accent : root.curColor
            x: (root.tileW - root._gridW) / 2 + (index % root._cols) * (root._cell + root.slotGap)
            y: (root.tileH - root._gridH) / 2 + Math.floor(index / root._cols) * (root._cell + root.slotGap)
        }
    }

    // Empty workspace = a simple hollow squircle with a plain border.
    Rectangle {
        anchors.centerIn: parent
        width: 17
        height: 17
        radius: 4
        visible: root._hasMeta && root.meta.count === 0
        color: "transparent"
        border.color: Theme.palette.textDim
        border.width: 1.5
    }

    MouseArea {
        hoverEnabled: true
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (root._hasMeta)
                niri.focusWorkspaceById(root.meta.id);
        }
        onEntered: {
            if (!root._hasMeta)
                return;
            root.hoveredId = root.meta.id;
            root.hoveredLabel = (root.meta.name ? root.meta.name : "Workspace " + root.meta.index) + " · " + root.meta.count + (root.meta.count === 1 ? " window" : " windows");
        }
        onExited: {
            if (root.hoveredId === root.meta.id)
                root.hoveredId = -1;
        }
    }

    property int hoveredId: -1
    property string hoveredLabel: ""

    // Hover tooltip (sits just below the bar)
    Rectangle {
        id: tip
        visible: root.hoveredId !== -1
        z: 20
        width: tipText.implicitWidth + 14
        height: tipText.implicitHeight + 6
        radius: 3
        color: Theme.palette.barBg
        border.color: Theme.palette.minimapBg
        border.width: 1

        x: Math.max(0, Math.min(parent.width - width, (parent.width - width) / 2))
        y: parent.height + 2

        Text {
            id: tipText
            anchors.centerIn: parent
            text: root.hoveredLabel
            color: Theme.palette.text
            font.family: Theme.palette.fontFamily
            font.pixelSize: 10
        }
    }
}
