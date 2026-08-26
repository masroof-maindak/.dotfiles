import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Networking
import "../themes"
import "utils.js" as Utils

// WiFi section: current connection readout with radio toggle. Deliberately
// non-interactive beyond power: no joining, no password prompts.
Column {
    id: root

    spacing: 0

    readonly property bool nmReady: Networking.backend === NetworkBackendType.NetworkManager
    readonly property bool wifiOn: root.nmReady && Networking.wifiEnabled
    readonly property var wifiDevice: {
        if (!root.nmReady)
            return null;
        const devices = Networking.devices.values;
        for (let i = 0; i < devices.length; i++)
            if (devices[i].type === DeviceType.Wifi)
                return devices[i];
        return null;
    }
    readonly property var activeNet: {
        const nets = root.wifiDevice?.networks?.values;
        if (nets)
            for (let i = 0; i < nets.length; i++)
                if (nets[i].connected)
                    return nets[i];
        return null;
    }
    readonly property bool secured: {
        const net = root.activeNet;
        return net ? net.security !== WifiSecurityType.Open && net.security !== WifiSecurityType.Owe : false;
    }

    property string privIp: ""

    Timer {
        interval: 5000
        running: root.visible && root.activeNet != null && root.wifiDevice != null
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refreshIp()
    }

    onVisibleChanged: if (visible)
        refreshIp()

    function refreshIp() {
        ipQuery.command = ["sh", "-c", "ip -4 addr show dev " + (wifiDevice?.name ?? "") + " scope global 2>/dev/null | grep -oP '(?<=inet )\\d+(\\.\\d+){3}' | head -n1"];
        ipQuery.running = true;
    }

    // Right-click opens impala for network management.
    function launchTui() {
        if (tuiProc.running)
            return;
        tuiProc.command = ["footclient", "impala"];
        tuiProc.running = true;
    }

    Process {
        id: tuiProc
        command: []
    }

    Process {
        id: ipQuery
        command: []
        stdout: StdioCollector {
            onStreamFinished: root.privIp = this.text.trim()
        }
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
                icon: Qt.resolvedUrl("../assets/" + Utils.wifiIcon(root.activeNet?.signalStrength ?? -1, root.secured, root.wifiOn) + ".svg")
                color: Theme.palette.text
            }

            Column {
                spacing: 2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 20 - 10 - 34 - 10

                Text {
                    text: {
                        if (!root.nmReady)
                            return "No network manager";
                        if (!root.wifiDevice)
                            return "No Wi-Fi device";
                        if (!Networking.wifiHardwareEnabled)
                            return "Wi-Fi hardware disabled";
                        if (!root.wifiOn)
                            return "Wi-Fi off";
                        return root.activeNet ? root.activeNet.name : "Not connected";
                    }
                    font.family: Theme.palette.fontFamily
                    font.pixelSize: 14
                    font.weight: Font.Bold
                    elide: Text.ElideRight
                    width: parent.width
                    color: Theme.palette.text
                }

                Text {
                    text: root.privIp
                    visible: root.wifiOn && root.activeNet != null && root.privIp !== ""
                    font.family: Theme.palette.fontFamily
                    font.pixelSize: 12
                    color: Theme.palette.textDim
                }
            }

            Toggle {
                anchors.verticalCenter: parent.verticalCenter
                enabled: root.nmReady && root.wifiDevice && Networking.wifiHardwareEnabled
                checked: root.wifiOn
                onActivated: {
                    Networking.wifiEnabled = !Networking.wifiEnabled;
                    refreshIp();
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton
            onClicked: root.launchTui()
        }
    }
}
