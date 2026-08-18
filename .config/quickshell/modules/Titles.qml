import QtQuick
import Niri
import "../themes"
import "utils.js" as Utils

Item {
    id: root

    property int maxWidth: 280
    property string screenName: ""

    Niri {
        id: niri
        Component.onCompleted: connect()
    }

    // Per-window snapshot keyed by window id, so we can pick the window that is
    // focused on *this* output when multiple monitors are in use.
    property var _rows: ({})
    property var fw: null

    Connections {
        target: niri
        function onConnected() {
            root._pick();
        }
        function onFocusedWindowChanged() {
            root._pick();
        }
    }
    Connections {
        target: niri.windows
        function onCountChanged() {
            root._pick();
        }
    }
    Connections {
        target: niri.workspaces
        function onCountChanged() {
            root._pick();
        }
    }

    function _set(id, d) {
        root._rows[id] = d;
        root._pick();
    }
    function _del(id) {
        delete root._rows[id];
        root._pick();
    }

    function _pick() {
        for (const k in root._rows) {
            const r = root._rows[k];
            if (!r._f)
                continue;
            if (root.screenName !== "" && Utils.wsOutput(niri.workspaces, r._ws) !== root.screenName)
                continue;
            root.fw = r;
            return;
        }
        root.fw = null;
    }

    Repeater {
        model: niri.windows
        delegate: Item {
            readonly property int _wid: model.id
            readonly property int _ws: model.workspaceId
            readonly property bool _f: model.isFocused
            readonly property string _app: model.appId
            readonly property string _title: model.title

            on_WsChanged: root._set(_wid, this)
            on_FChanged: root._set(_wid, this)
            on_AppChanged: root._set(_wid, this)
            on_TitleChanged: root._set(_wid, this)
            Component.onCompleted: root._set(_wid, this)
            Component.onDestruction: root._del(_wid)
        }
    }

    width: Math.min(maxWidth, Math.max(appLine.implicitWidth, titleLine.implicitWidth))
    implicitHeight: column.implicitHeight

    Column {
        id: column
        width: parent.width
        spacing: -2
        anchors.verticalCenter: parent.verticalCenter

        Text {
            id: appLine
            width: parent.width
            horizontalAlignment: Text.AlignLeft
            text: root.fw?._app ?? "—"
            color: Theme.palette.textSecondary
            font.family: Theme.palette.fontFamily
            font.pixelSize: 12
            font.weight: Font.Normal
            elide: Text.ElideRight
        }

        Text {
            id: titleLine
            width: parent.width
            horizontalAlignment: Text.AlignLeft
            text: root.fw?._title ?? "—"
            color: Theme.palette.text
            font.family: Theme.palette.fontFamily
            font.pixelSize: 14
            font.weight: Font.Bold
            elide: Text.ElideRight
            maximumLineCount: 1
        }
    }
}
