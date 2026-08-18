import QtQuick
import Quickshell
import Quickshell.Services.Pam

// Shared state for all lock surfaces on every screen. Kept in one object so
// the password text, failure state and PAM conversation stay in sync across
// monitors.
Scope {
    id: root

    signal unlocked

    // Current user being authenticated. pam defaults to the logged-in user,
    // which is what the surface displays.
    readonly property string user: pam.user

    property string currentText: ""
    property bool unlockInProgress: false
    property bool showFailure: false

    // Clear the failure message once the user starts typing again.
    onCurrentTextChanged: showFailure = false

    function tryUnlock() {
        if (root.currentText === "")
            return;
        root.unlockInProgress = true;
        pam.start();
    }

    PamContext {
        id: pam

        // Custom pam config so the system one (which may expect tokens this
        // UI never sends, e.g. a fingerprint prompt) doesn't break the lock.
        // Resolved relative to this file, i.e. ./pam/password.conf.
        configDirectory: "pam"
        config: "password.conf"

        // pam_unix asks for a response for the password prompt.
        onPamMessage: {
            if (this.responseRequired) {
                this.respond(root.currentText);
            }
        }

        // pam_unix won't send any useful messages, so we only care about the
        // completion status.
        onCompleted: result => {
            if (result == PamResult.Success) {
                root.unlocked();
            } else {
                root.currentText = "";
                root.showFailure = true;
            }

            root.unlockInProgress = false;
        }
    }
}
