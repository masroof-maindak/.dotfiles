import QtQuick
import "../themes"

// Dropdown arrow button on the bar. Click toggles the status panel; the
// chevron flips while open.
Item {
    id: root

    // Bar window the panel is anchored to, so it drops below the bar.
    property var anchorWindow: null
    property bool popupEnabled: true

    implicitWidth: 32
    implicitHeight: 34

    readonly property bool open: panel.isOpen

    Item {
        anchors.centerIn: parent
        width: 28
        height: 28

        // Circular hover highlight, barely a step above the bar background.
        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: mouse.containsMouse || root.open ? Theme.palette.minimapBg : "transparent"
        }

        Icon {
            anchors.centerIn: parent
            width: 18
            height: 18
            icon: Qt.resolvedUrl("../assets/ChevronDown.svg")
            color: mouse.containsMouse || root.open ? Theme.palette.text : Theme.palette.textSecondary
            rotation: root.open ? 180 : 0

            Behavior on rotation {
                NumberAnimation {
                    duration: 160
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: root.popupEnabled
        cursorShape: Qt.PointingHandCursor
        onClicked: root.open ? panel.close() : panel.open()
    }

    StatusPanel {
        id: panel
        anchorWindow: root.anchorWindow
        // Parent is the bar's fill item, so root.x is window-relative.
        anchorX: root.x
        anchorWidth: root.width
    }
}
