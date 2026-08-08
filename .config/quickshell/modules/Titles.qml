import QtQuick
import Niri
import "../themes"

Item {
    id: root

    property alias niri: niri

    Niri {
        id: niri
        Component.onCompleted: connect()
    }

    width: Math.min(maxWidth, Math.max(appLine.implicitWidth, titleLine.implicitWidth))
    implicitHeight: column.implicitHeight
    height: implicitHeight

    property int maxWidth: 280

    Column {
        id: column
        width: parent.width
        spacing: -2
        anchors.verticalCenter: parent.verticalCenter

        Text {
            id: appLine
            width: parent.width
            horizontalAlignment: Text.AlignLeft
            text: niri.focusedWindow?.appId ?? "—"
            color: Theme.palette.textSecondary
            font.family: Theme.palette.fontFamily
            font.pixelSize: 12
            font.weight: Font.Normal
            elide: Text.ElideRight
        }

        Text {
            id: titleLine
            width: parent.width
            horizontalAlignment: Text.AlignLeft
            text: niri.focusedWindow?.title ?? "—"
            color: Theme.palette.text
            font.family: Theme.palette.fontFamily
            font.pixelSize: 14
            font.weight: Font.Bold
            elide: Text.ElideRight
            maximumLineCount: 1
        }
    }
}
