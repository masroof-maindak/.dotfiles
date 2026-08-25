import QtQuick
import Quickshell.Services.Pipewire
import "../themes"

// Themed volume mixer row for one pipewire node (sink or app stream).
Item {
    id: root

    required property var node

    property color lowColor: Theme.palette.red

    // application.name -> description -> name, with media.name appended.
    readonly property string label: {
        if (!node)
            return "";
        const app = node.properties["application.name"] ?? (node.description !== "" ? node.description : node.name);
        const media = node.properties["media.name"];
        return media !== undefined ? app + " - " + media : app;
    }
    readonly property int pct: Math.floor((node?.audio?.volume ?? 0) * 100)
    readonly property bool muted: node?.audio?.muted ?? false

    implicitHeight: column.implicitHeight

    // Bind the node so its audio properties become live.
    PwObjectTracker {
        objects: root.node ? [root.node] : []
    }

    Column {
        id: column
        width: parent.width
        spacing: 6
        opacity: root.muted ? 0.5 : 1

        Text {
            width: parent.width
            elide: Text.ElideRight
            text: root.label
            font.family: Theme.palette.fontFamily
            font.pixelSize: 14
            color: root.muted ? Theme.palette.textDim : Theme.palette.text

            // Clicking the name toggles mute.
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (root.node?.audio)
                        root.node.audio.muted = !root.node.audio.muted;
                }
            }
        }

        Item {
            id: slider
            width: parent.width
            height: 16
            // Reserve room for the percentage label on the right.
            readonly property int trackWidth: width - 44

            Rectangle {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: slider.trackWidth
                height: 5
                radius: 2
                color: Theme.palette.barBorder

                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width * Math.min(1, Math.max(0, root.node?.audio?.volume ?? 0))
                    radius: 2
                    color: root.muted ? root.lowColor : Theme.palette.accent
                }
            }

            Text {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: 44
                horizontalAlignment: Text.AlignRight
                text: root.muted ? "muted" : root.pct + "%"
                font.family: Theme.palette.fontFamily
                font.pixelSize: 13
                font.weight: Font.Bold
                color: root.muted ? Theme.palette.textDim : Theme.palette.textSecondary
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                function setFromMouse(mouse) {
                    const v = Math.max(0, Math.min(1, mouse.x / slider.trackWidth));
                    if (root.node?.audio)
                        root.node.audio.volume = v;
                }

                onPressed: mouse => setFromMouse(mouse)
                onPositionChanged: mouse => setFromMouse(mouse)
                onWheel: wheel => {
                    if (!root.node?.audio)
                        return;
                    const delta = wheel.angleDelta.y > 0 ? 0.01 : -0.01;
                    root.node.audio.volume = Math.max(0, Math.min(1, root.node.audio.volume + delta));
                }
            }
        }
    }
}
