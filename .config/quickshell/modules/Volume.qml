import QtQuick
import Quickshell.Services.Pipewire
import "../themes"
import "utils.js" as Utils

Item {
    id: root

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    property color textColor: Theme.palette.text
    property int iconSize: 25
    property int fontHeight: 14

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real vol: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property int pct: Math.round(vol * 100)

    // PwNode audio properties are only valid while tracked
    PwObjectTracker {
        objects: root.sink ? [root.sink] : []
    }

    readonly property string iconName: Utils.volumeIcon(root.vol, root.muted)

    Row {
        id: content
        spacing: 6
        anchors.verticalCenter: parent.verticalCenter

        Icon {
            width: root.iconSize
            height: root.iconSize
            anchors.verticalCenter: parent.verticalCenter
            icon: Qt.resolvedUrl("../assets/" + root.iconName + ".svg")
            color: root.textColor
        }

        Text {
            text: root.pct
            font.family: Theme.palette.fontFamily
            font.pixelSize: root.fontHeight
            font.weight: Font.Bold
            color: root.textColor
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    function setVolume(v) {
        if (root.sink?.audio)
            root.sink.audio.volume = Math.max(0, Math.min(1, v));
    }

    function toggleMute() {
        if (root.sink?.audio)
            root.sink.audio.muted = !root.sink.audio.muted;
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.toggleMute()
        onWheel: wheel => {
            const delta = wheel.angleDelta.y > 0 ? 0.01 : -0.01;
            root.setVolume(root.vol + delta);
        }
    }
}
