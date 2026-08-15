pragma Singleton
import QtQuick
import Quickshell.Io

// Follows the current darkman mode (light/dark). `darkman watch` prints the
// current mode once at startup, then each mode change as it happens, so the
// theme updates are pushed rather than polled. If the process exits (e.g.
// darkman is stopped) it is restarted so the bar keeps following the mode.
Item {
    id: root

    readonly property bool dark: _dark

    property bool _dark: false

    Process {
        id: watcher
        command: ["darkman", "watch"]
        running: true
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                const s = String(data).trim()
                if (s === "dark" || s === "light")
                    root._dark = s === "dark"
            }
        }
        onExited: { restartTimer.restart() }
    }

    Timer {
        id: restartTimer
        interval: 10000
        onTriggered: {
            watcher.running = false
            watcher.running = true
        }
    }
}
