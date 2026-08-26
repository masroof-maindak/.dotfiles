import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

// StatusNotifier tray icons. Left click activates, right click opens the
// app's menu (or secondary action when there is no menu). The row hugs the
// right edge of the width supplied by the host.
Item {
    id: root

    implicitHeight: iconRow.height

    Row {
        id: iconRow
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        spacing: 6

    Repeater {
        model: SystemTray.items

        delegate: Item {
            id: entry

            required property var modelData

            width: 18
            height: 18
            anchors.verticalCenter: parent.verticalCenter

            Image {
                anchors.fill: parent
                anchors.margins: 1
                source: entry.modelData.icon
                asynchronous: true
                fillMode: Image.PreserveAspectFit
                sourceSize.width: width * 2
                sourceSize.height: height * 2
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                cursorShape: Qt.PointingHandCursor

                onClicked: mouse => {
                    if (mouse.button === Qt.RightButton) {
                        if (entry.modelData.hasMenu)
                            entry.menu.open();
                        else if (!entry.modelData.onlyMenu)
                            entry.modelData.secondaryActivate();
                    } else {
                        if (!entry.modelData.onlyMenu)
                            entry.modelData.activate();
                        else if (entry.modelData.hasMenu)
                            entry.menu.open();
                    }
                }
            }

            QsMenuAnchor {
                id: menu

                menu: entry.modelData.menu
                anchor.item: entry
                anchor.edges: Edges.Bottom
                anchor.gravity: Edges.Bottom
                anchor.margins.top: 4
                anchor.adjustment: PopupAdjustment.Flip
            }
        }
    }
    }
}