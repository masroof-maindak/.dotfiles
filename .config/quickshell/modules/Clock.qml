import QtQuick
import Quickshell
import "../themes"

Item {
    id: root

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
}
