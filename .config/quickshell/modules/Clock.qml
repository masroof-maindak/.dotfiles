import QtQuick
import Quickshell
import "../themes"

Item {
    id: root

    // Bar window the calendar popup is anchored to, so it drops below the bar
    // rather than hugging the clock inside it.
    property var anchorWindow: null

    implicitWidth: column.implicitWidth
    implicitHeight: column.implicitHeight

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Column {
        id: column
        anchors.centerIn: parent
        spacing: -2

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(clock.date, "hh:mm a")
            color: Theme.palette.text
            font.family: Theme.palette.fontFamily
            font.pixelSize: 16
            font.weight: Font.Bold
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(clock.date, "yyyy-MM-dd")
            color: Theme.palette.textSecondary
            font.family: Theme.palette.fontFamily
            font.pixelSize: 14
            font.weight: Font.Normal
        }
    }

    // Hovering the date block shows the calendar popup below it.
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: popup.visible = true
        onExited: hideTimer.start()
    }

    PopupWindow {
        id: popup
        visible: false
        color: "transparent"
        // Below the bar's bottom edge, 8px off it and the screen's right edge.
        anchor.window: root.anchorWindow
        anchor.rect.x: root.anchorWindow ? root.anchorWindow.width - width - 8 : 0
        anchor.rect.y: root.anchorWindow ? root.anchorWindow.height + 8 : 0
        implicitWidth: cal.implicitWidth + 20
        implicitHeight: cal.implicitHeight + 20

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

            Calendar {
                id: cal
                anchors.centerIn: parent
                date: clock.date
            }
        }
    }

    Timer {
        id: hideTimer
        interval: 150
        onTriggered: popup.visible = false
    }
}
