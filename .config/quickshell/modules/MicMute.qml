import QtQuick
import Quickshell.Services.Pipewire
import "../themes"

// Microphone mute row shown above the mixer entries.
Item {
    id: root

    width: parent.width
    height: row.height

    readonly property var source: Pipewire.defaultAudioSource
    readonly property bool muted: source?.audio?.muted ?? false

    // PwNode audio properties are only valid while tracked
    PwObjectTracker {
        objects: root.source ? [root.source] : []
    }

    Item {
        id: row
        width: parent.width
        height: Math.max(icon.height, labels.height)

        Icon {
            id: icon
            width: 20
            height: 20
            anchors.verticalCenter: parent.verticalCenter
            icon: Qt.resolvedUrl("../assets/" + (root.muted ? "MicrophoneOff" : "Microphone") + ".svg")
            color: root.muted ? Theme.palette.red : Theme.palette.text
        }

        Column {
            id: labels
            spacing: 2
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: icon.right
            anchors.leftMargin: 10
            anchors.right: stateText.left
            anchors.rightMargin: 10

            Text {
                text: "Microphone"
                font.family: Theme.palette.fontFamily
                font.pixelSize: 14
                font.weight: Font.Bold
                color: Theme.palette.text
            }

            Text {
                text: root.muted ? "muted" : "on"
                font.family: Theme.palette.fontFamily
                font.pixelSize: 12
                color: Theme.palette.textDim
            }
        }

        Text {
            id: stateText
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            text: root.muted ? "MUTED" : "ON"
            font.family: Theme.palette.fontFamily
            font.pixelSize: 11
            font.weight: Font.Bold
            color: root.muted ? Theme.palette.red : Theme.palette.textSecondary
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (root.source?.audio)
                    root.source.audio.muted = !root.source.audio.muted;
            }
        }
    }
}
