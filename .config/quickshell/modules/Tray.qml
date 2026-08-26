import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

// StatusNotifier tray icons. Left click activates, right click opens the
// app's menu via display() at explicit coordinates (QsMenuAnchor can't
// anchor off an item inside a popup window). The row hugs the right edge
// of the width supplied by the host.
Item {
    id: root

    // Host window the menus are positioned against, plus this row's offset
    // within it.
    property var anchorWindow: null
    property real originX: 0
    property real originY: 0

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

            width: 20
            height: 20
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
                            entry.openMenu();
                        else if (!entry.modelData.onlyMenu)
                            entry.modelData.secondaryActivate();
                    } else {
                        if (!entry.modelData.onlyMenu)
                            entry.modelData.activate();
                        else if (entry.modelData.hasMenu)
                            entry.openMenu();
                    }
                }
            }

            function openMenu() {
                const pos = mapToItem(null, 0, 0);
                modelData.display(root.anchorWindow, root.originX + pos.x + width / 2, root.originY + pos.y + height + 4);
            }
        }
    }
    }
}
