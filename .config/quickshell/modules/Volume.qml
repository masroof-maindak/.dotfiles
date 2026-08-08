import QtQuick
import QtQuick.Effects
import Quickshell.Services.Pipewire
import "../themes"

Item {
    id: root

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight
    width: implicitWidth
    height: implicitHeight

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

    readonly property string iconName: {
        if (muted)
            return "Volume-mute-outline";
        if (vol <= 0.01)
            return "Volume-off-outline";
        if (vol < 0.5)
            return "Volume-medium-outline";
        return "Volume-high-outline";
    }

    Row {
        id: content
        spacing: 6
        anchors.verticalCenter: parent.verticalCenter

        MultiEffect {
            width: root.iconSize
            height: root.iconSize
            anchors.verticalCenter: parent.verticalCenter
            source: Image {
                width: root.iconSize
                height: root.iconSize
                source: Qt.resolvedUrl("../assets/" + root.iconName + ".svg")
                sourceSize.width: root.iconSize
                sourceSize.height: root.iconSize
            }
            colorization: 1
            colorizationColor: root.textColor
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
            const delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
            root.setVolume(root.vol + delta);
        }
    }
}
