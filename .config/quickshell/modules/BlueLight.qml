import QtQuick
import Quickshell.Io
import "../themes"

// Blue light filter row backed by wlsunset, mirroring wlsunset-ctl:
// state comes from pgrep, on/off spawn or pkill the daemon.
Item {
    id: root

    // Set by the host while the panel is open; gates state polling.
    property bool active: false
    readonly property bool running: stateText === "yes"
    property string stateText: ""

    width: parent.width
    height: row.height

    function refresh() {
        query.running = true;
    }

    // Recheck shortly after a toggle so the UI follows immediately.
    Timer {
        id: settle
        interval: 500
        onTriggered: root.refresh()
    }

    Timer {
        interval: 3000
        running: root.active
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }

    Process {
        id: query
        command: ["sh", "-c", "pgrep -x wlsunset >/dev/null && echo yes || echo no"]
        stdout: StdioCollector {
            onStreamFinished: root.stateText = this.text.trim()
        }
    }

    Process {
        id: killProc
        command: []
        onExited: settle.restart()
    }

    // Owns the daemon when started from here.
    Process {
        id: wlsunsetProc
        command: ["wlsunset", "-s", "23:00", "-S", "07:00", "-d", "480", "-t", "4200"]
        onStarted: settle.restart()
    }

    function setRunning(on) {
        if (on) {
            // wlsunsetProc.running covers our own child synchronously;
            // root.running covers external instances (async).
            if (!root.running && !wlsunsetProc.running)
                wlsunsetProc.running = true;
        } else {
            killProc.command = ["pkill", "-x", "wlsunset"];
            killProc.running = true;
        }
    }

    Item {
        id: row
        width: parent.width
        height: Math.max(icon.height, labels.height)

        Icon {
            id: icon
            width: 20
            height: 20
            anchors.verticalCenter: parent.verticalCenter
            icon: Qt.resolvedUrl("../assets/PowerSleep.svg")
            color: Theme.palette.text
        }

        Column {
            id: labels
            spacing: 2
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: icon.right
            anchors.leftMargin: 10
            anchors.right: toggle.left
            anchors.rightMargin: 10

            Text {
                text: "Blue light"
                font.family: Theme.palette.fontFamily
                font.pixelSize: 14
                font.weight: Font.Bold
                color: Theme.palette.text
            }

            Text {
                text: root.running ? "on · 4200K" : "off"
                font.family: Theme.palette.fontFamily
                font.pixelSize: 12
                color: Theme.palette.textDim
            }
        }

        Toggle {
            id: toggle
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            checked: root.running
            onActivated: {
                root.setRunning(!root.running);
                settle.restart();
            }
        }
    }
}
