import QtQuick
import Quickshell.Services.Pipewire
import "../themes"

// Shared mixer popup contents: system output plus every stream playing
// into it. The host supplies the width.
Item {
    id: root

    implicitHeight: column.implicitHeight

    PwNodeLinkTracker {
        id: linkTracker
        node: Pipewire.defaultAudioSink
    }

    Column {
        id: column
        anchors.fill: parent
        spacing: 14

        MixerEntry {
            width: parent.width
            node: Pipewire.defaultAudioSink
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
