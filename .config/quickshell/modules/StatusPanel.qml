import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "../themes"

// Click-toggled dropdown panel: content column plus a fullscreen catcher
// window that closes it on outside clicks. The catcher's input mask has a
// hole over the panel so clicks land on the popup beneath the overlay.
Scope {
    id: root

    property var anchorWindow: null
    property real anchorX: 0
    property real anchorWidth: 32

    readonly property int margin: 8
    readonly property int panelWidth: 300
    // Centered under the chevron, clamped to screen edges.
    readonly property int panelX: {
        const w = root.anchorWindow;
        if (!w)
            return 0;
        return Math.max(margin, Math.min(w.width - panelWidth - margin, anchorX + anchorWidth / 2 - panelWidth / 2));
    }
    readonly property int panelY: (root.anchorWindow?.height ?? 0) + margin

    function open() {
        PopupManager.open(popup);
    }

    function close() {
        PopupManager.close(popup);
    }

    readonly property bool isOpen: popup.visible

    PopupWindow {
        id: popup
        visible: false
        color: "transparent"
        anchor.window: root.anchorWindow
        anchor.adjustment: PopupAdjustment.Flip
        anchor.rect.x: root.panelX
        anchor.rect.y: root.panelY
        implicitWidth: root.panelWidth
        implicitHeight: contentCol.implicitHeight + contentCol.anchors.margins * 2

        Rectangle {
            anchors.fill: parent
            radius: 4
            color: Theme.palette.barBg
            border.color: Theme.palette.barBorder
            border.width: 1

            MouseArea {
                anchors.fill: parent
            }

            Column {
                id: contentCol
                anchors.fill: parent
                anchors.margins: 14
                spacing: 12

                NetworkContent {
                    width: parent.width
                }

                BluetoothContent {
                    width: parent.width
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: Theme.palette.barBorder
                }

                BlueLight {
                    id: blueLightRow
                    width: parent.width
                    active: root.isOpen
                }

                Caffeine {
                    id: caffeineRow
                    width: parent.width
                    active: root.isOpen
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: Theme.palette.barBorder
                }

                SystemGraphs {
                    width: parent.width
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: Theme.palette.barBorder
                }

                Item {
                    id: sessionRow
                    width: parent.width
                    height: Math.max(lockButton.height, tray.height)

                    // Power menu (niri Mod+G equivalent).
                    Process {
                        id: powerProc
                        command: []
                    }

                    Rectangle {
                        id: lockButton
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }
                        width: 30
                        height: 30
                        radius: width / 2
                        color: lockMouse.containsMouse ? Theme.palette.minimapBg : "transparent"

                        Icon {
                            anchors.centerIn: parent
                            width: 20
                            height: 20
                            icon: Qt.resolvedUrl("../assets/Power.svg")
                            color: lockMouse.containsMouse ? Theme.palette.text : Theme.palette.textSecondary
                        }

                        MouseArea {
                            id: lockMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.close();
                                powerProc.command = ["fuzzel-pwrmenu"];
                                powerProc.running = true;
                            }
                        }
                    }

                    Tray {
                        id: tray
                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }
                        width: parent.width - lockButton.width - 8
                    }
                }
            }
        }
    }

    // Created only while the panel is open.
    LazyLoader {
        active: popup.visible

        PanelWindow {
            screen: root.anchorWindow?.screen ?? null
            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }
            exclusiveZone: -1
            color: "transparent"
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

            mask: Region {
                Region {
                    x: root.panelX - 8
                    y: root.panelY
                    width: root.panelWidth + 16
                    height: popup.implicitHeight
                    intersection: Intersection.Subtract
                }
            }

            MouseArea {
                anchors.fill: parent
                onPressed: root.close()
            }
        }
    }
}
