import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Bluetooth
import "../themes"

// Bluetooth section: adapter power toggle; right-click opens bluetui for
// device management.
Column {
    id: root

    spacing: 0

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property bool hasAdapter: adapter !== null
    readonly property int connectedCount: {
        let n = 0;
        if (!root.hasAdapter)
            return n;
        const devices = adapter.devices.values;
        for (let i = 0; i < devices.length; i++)
            if (devices[i].connected)
                n++;
        return n;
    }

    function launchTui() {
        if (tuiProc.running)
            return;
        tuiProc.command = ["footclient", "bluetui"];
        tuiProc.running = true;
    }

    Process {
        id: tuiProc
        command: []
    }

    Item {
        width: parent.width
        height: statusRow.height

        Row {
            id: statusRow
            width: parent.width
            spacing: 10

            Icon {
                width: 20
                height: 20
                anchors.verticalCenter: parent.verticalCenter
                icon: Qt.resolvedUrl("../assets/" + (!root.hasAdapter || !adapter.enabled ? "BluetoothOff" : root.connectedCount > 0 ? "BluetoothConnect" : "Bluetooth") + ".svg")
                color: Theme.palette.text
            }

            Column {
                spacing: 2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 20 - 10 - 34 - 10

                Text {
                    text: root.hasAdapter ? "Bluetooth" : "No bluetooth adapter"
                    font.family: Theme.palette.fontFamily
                    font.pixelSize: 14
                    font.weight: Font.Bold
                    color: Theme.palette.text
                }

                Text {
                    text: {
                        if (!root.hasAdapter || !adapter.enabled)
                            return "";
                        if (adapter.discovering)
                            return "Scanning…";
                        return adapter.name;
                    }
                    visible: text !== ""
                    font.family: Theme.palette.fontFamily
                    font.pixelSize: 12
                    color: Theme.palette.textDim
                }
            }

            Toggle {
                anchors.verticalCenter: parent.verticalCenter
                enabled: root.hasAdapter
                checked: root.hasAdapter && adapter.enabled
                onActivated: adapter.enabled = !adapter.enabled
            }
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton
            onClicked: root.launchTui()
        }
    }
}
