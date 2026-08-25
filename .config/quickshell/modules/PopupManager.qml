pragma Singleton
import QtQuick

// Ensures only one hover popup is visible at a time: opening one force-hides
// whichever popup was shown before it.
QtObject {
    property var current: null

    function open(popup) {
        if (current === popup) {
            popup.visible = true;
            return;
        }
        if (current)
            current.visible = false;
        current = popup;
        popup.visible = true;
    }

    function close(popup) {
        if (current === popup)
            current = null;
        popup.visible = false;
    }
}
