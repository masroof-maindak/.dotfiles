import QtQuick
import Quickshell

// Windowed preview of the lockscreen for testing, run with:
// quickshell -p test.qml
ShellRoot {
    LockscreenContext {
        id: lockContext
        onUnlocked: Qt.quit()
    }

    FloatingWindow {
        width: 1000
        height: 700
        color: "transparent"

        LockscreenSurface {
            anchors.fill: parent
            context: lockContext
        }
    }

    // exit the example if the window closes
    Connections {
        target: Quickshell
        function onLastWindowClosed() {
            Qt.quit();
        }
    }
}
