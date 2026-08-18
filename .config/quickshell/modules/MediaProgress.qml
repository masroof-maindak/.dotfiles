import QtQuick

// Reusable seekable music progress bar, same style as the media popup card.
Rectangle {
    id: root

    required property var player
    required property real position
    required property real length

    property color trackColor
    property color fillColor

    width: 0
    height: 16
    color: root.trackColor

    Rectangle {
        width: parent.width * (root.length > 0 ? root.position / root.length : 0)
        height: parent.height
        color: root.fillColor
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: mouse => {
            if (!root.player || root.length <= 0)
                return;
            const fraction = mouse.x / width;
            const target = fraction * root.length;
            root.player.seek(target - root.position);
        }
    }
}
