import QtQuick
import Quickshell.Io
import "../themes"

// Caffeine row backed by stasis: state reads from `stasis info --json`
// (class "manually_inhibited"), toggle runs `stasis toggle-inhibit`.
Item {
    id: root

    // Set by the host while the panel is open; gates state polling.
    property bool active: false
    readonly property bool running: stateClass === "manually_inhibited"
    readonly property bool stasisPresent: stateRaw !== ""
    property string stateRaw: ""
    property string stateClass: ""

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
        command: ["stasis", "info", "--json"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.stateRaw = this.text.trim();
                root.stateClass = "";
                try {
                    root.stateClass = JSON.parse(root.stateRaw).class ?? "";
                } catch (e) {}
            }
        }
    }

    Process {
        id: toggleProc
        command: ["stasis", "toggle-inhibit"]
        onStarted: settle.restart()
    }

    function setRunning(on) {
        if (root.running === on)
            return;
        toggleProc.running = true;
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
            icon: Qt.resolvedUrl("../assets/" + (root.running ? "SleepOff" : "Sleep") + ".svg")
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
                text: "Keep Awake"
                font.family: Theme.palette.fontFamily
                font.pixelSize: 14
                font.weight: Font.Bold
                color: Theme.palette.text
            }

            Text {
                text: !root.stasisPresent ? "stasis not running" : root.running ? "on · idle inhibited" : "off"
                font.family: Theme.palette.fontFamily
                font.pixelSize: 12
                color: Theme.palette.textDim
            }
        }

        Toggle {
            id: toggle
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            enabled: root.stasisPresent
            checked: root.running
            onActivated: {
                root.setRunning(!root.running);
                settle.restart();
            }
        }
    }
}
