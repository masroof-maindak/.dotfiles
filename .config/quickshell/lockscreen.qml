import Quickshell
import Quickshell.Wayland

// Run with: quickshell -p lockscreen.qml
ShellRoot {
    // Stores all the information shared between the lock surfaces on each screen.
    LockscreenContext {
        id: lockContext

        onUnlocked: {
            // Unlock the screen before exiting, or the compositor will display
            // a fallback lock you can't interact with.
            lock.locked = false

            Qt.quit()
        }
    }

    WlSessionLock {
        id: lock

        // Lock the session immediately when quickshell starts.
        locked: true

        WlSessionLockSurface {
            LockscreenSurface {
                anchors.fill: parent
                context: lockContext
            }
        }
    }
}
