import QtQuick
import Quickshell
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
        implicitHeight: contentCol.implicitHeight + 32

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
                anchors.margins: 16
                spacing: 14

                NetworkContent {
                    width: parent.width
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: Theme.palette.barBorder
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

                Tray {
                    width: parent.width
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
