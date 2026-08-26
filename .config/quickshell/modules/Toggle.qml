import QtQuick
import "../themes"

// Small pill switch. The caller owns the state: `checked` is a binding to
// the backing service and `activated()` fires on click.
Rectangle {
    id: root

    property bool checked: false
    signal activated()

    implicitWidth: 34
    implicitHeight: 18
    radius: height / 2
    color: root.checked ? Theme.palette.accent : Theme.palette.barBorder
    Behavior on color {
        ColorAnimation {
            duration: 120
        }
    }

    Rectangle {
        width: parent.height - 4
        height: width
        radius: width / 2
        anchors.verticalCenter: parent.verticalCenter
        x: root.checked ? parent.width - width - 2 : 2
        color: Theme.palette.text

        Behavior on x {
            NumberAnimation {
                duration: 120
                easing.type: Easing.OutCubic
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.activated()
    }
}
