import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import "../themes"
import "utils.js" as Utils

Scope {
    id: root

    // Bind the pipewire node so its volume will be tracked
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    property bool primed: false

    Connections {
        target: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio : null

        function onVolumeChanged() {
            if (!root.primed) {
                root.primed = true;
                return;
            }
            root.shouldShowOsd = true;
            hideTimer.restart();
        }

        function onMutedChanged() {
            if (!root.primed) {
                root.primed = true;
                return;
            }
            root.shouldShowOsd = true;
            hideTimer.restart();
        }
    }

    readonly property real vol: Pipewire.defaultAudioSink?.audio?.volume ?? 0
    readonly property bool muted: Pipewire.defaultAudioSink?.audio?.muted ?? false

    readonly property string iconName: Utils.volumeIcon(root.vol, root.muted)

    property bool shouldShowOsd: false

    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: root.shouldShowOsd = false
    }

    // The OSD window is created on demand so its memory overhead is dropped when hidden.
    LazyLoader {
        active: root.shouldShowOsd

        PanelWindow {
            // Since the panel's screen is unset, it will be picked by the compositor
            // when the window is created. Most compositors pick the current active monitor.

            anchors.bottom: true
            margins.bottom: screen.height / 12
            exclusiveZone: 0

            implicitWidth: 320
            implicitHeight: 44
            color: "transparent"

            // An empty click mask prevents the window from blocking mouse events.
            mask: Region {}

            Rectangle {
                anchors.fill: parent
                radius: height / 2
                color: Theme.palette.barBg
                border.color: Theme.palette.barBorder
                border.width: 2

                RowLayout {
                    anchors {
                        fill: parent
                        leftMargin: 12
                        rightMargin: 16
                    }

                    Icon {
                        Layout.preferredWidth: 24
                        Layout.preferredHeight: 24
                        icon: Qt.resolvedUrl("../assets/" + root.iconName + ".svg")
                        color: Theme.palette.text
                    }

                    Rectangle {
                        // Stretches to fill all left-over space
                        Layout.fillWidth: true

                        implicitHeight: 8
                        radius: height / 2
                        color: Qt.rgba(Theme.palette.barBorder.r, Theme.palette.barBorder.g, Theme.palette.barBorder.b, 0.5)

                        Rectangle {
                            anchors {
                                left: parent.left
                                top: parent.top
                                bottom: parent.bottom
                            }

                            width: parent.width * root.vol
                            radius: parent.radius
                            color: Theme.palette.accent
                        }
                    }
                }
            }
        }
    }
}
