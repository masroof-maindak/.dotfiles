import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import "../themes"
import "utils.js" as Utils

Item {
    id: root

    // Bar window the mixer popup is anchored to, so it drops below the bar.
    property var anchorWindow: null

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
        hoverEnabled: true
        onClicked: root.toggleMute()
        onEntered: mixer.visible = true
        onExited: hideTimer.start()
        onWheel: wheel => {
            const delta = wheel.angleDelta.y > 0 ? 0.01 : -0.01;
            root.setVolume(root.vol + delta);
        }
    }

    // Mixer shown on hover: system output plus every stream playing into it.
    PopupWindow {
        id: mixer
        visible: false
        color: "transparent"
        anchor.window: root.anchorWindow
        // Centered under the volume icon, clamped 8px from either screen edge
        // and 8px below the bar's bottom edge.
        anchor.rect.x: root.anchorWindow ? Math.max(8, Math.min(root.anchorWindow.width - width - 8, root.x + root.width / 2 - width / 2)) : 0
        anchor.rect.y: root.anchorWindow ? root.anchorWindow.height + 8 : 0
        implicitWidth: 300
        implicitHeight: mixerCol.implicitHeight + 40

        PwNodeLinkTracker {
            id: linkTracker
            node: root.sink
        }

        Rectangle {
            anchors.fill: parent
            radius: 4
            color: Theme.palette.barBg
            border.color: Theme.palette.barBorder
            border.width: 1

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: hideTimer.stop()
                onExited: hideTimer.start()
            }

            Column {
                id: mixerCol
                anchors.fill: parent
                anchors.margins: 20
                spacing: 14

                MixerEntry {
                    width: parent.width
                    node: root.sink
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: Theme.palette.barBorder
                }

                Repeater {
                    id: streams
                    model: linkTracker.linkGroups

                    delegate: MixerEntry {
                        required property var modelData

                        width: parent.width
                        node: modelData.source
                    }
                }

                Text {
                    visible: streams.count === 0
                    text: "No active apps"
                    font.family: Theme.palette.fontFamily
                    font.pixelSize: 14
                    color: Theme.palette.textDim
                }
            }
        }
    }

    Timer {
        id: hideTimer
        interval: 150
        onTriggered: mixer.visible = false
    }
}
