import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import "./modules"
import "./themes"

Rectangle {
    id: root

    required property LockscreenContext context

    color: Theme.palette.barBg

    Image {
        anchors.fill: parent
        source: Qt.resolvedUrl(Darkman.dark ? "./lockscreen-bg.png" : "./lockscreen-bg-light.png")
        fillMode: Image.PreserveAspectCrop
        clip: true
        smooth: true
    }

    readonly property color textColor: Theme.palette.text
    readonly property color secondaryColor: Theme.palette.textSecondary
    readonly property color dimColor: Theme.palette.textDim
    readonly property color accentColor: Theme.palette.accent
    readonly property color borderColor: Theme.palette.barBorder
    readonly property color errorColor: Theme.palette.red
    readonly property string fontFamily: "Roboto"

    // ---- now playing state (same selection logic as the bar's Media module)

    property var player: null

    Connections {
        target: Mpris.players
        function onValuesChanged() {
            root._reselect();
        }
    }

    Connections {
        target: root.player
        function onIsPlayingChanged() {
            root._reselect();
        }
    }

    Component.onCompleted: root._reselect()

    function _reselect() {
        let playing = null;
        let last = null;
        for (const p of Mpris.players.values) {
            last = p;
            if (p.isPlaying)
                playing = p;
        }
        root.player = playing ?? last;
    }

    readonly property bool hasTrack: !!player && (player.isPlaying || player.length > 0)
    readonly property string title: player?.trackTitle ?? ""
    readonly property string artist: player?.trackArtist ?? ""
    readonly property string artUrl: player?.trackArtUrl ?? ""
    readonly property real pos: player?.position ?? 0
    readonly property real len: player?.length ?? 0
    readonly property bool playing: player?.isPlaying ?? false

    // MPRIS doesn't push position continuously, so we emit the change ourselves
    // to keep the progress bar moving (only while playing).
    Timer {
        interval: 200
        repeat: true
        running: root.player?.isPlaying ?? false
        onTriggered: root.player?.positionChanged()
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 8

        Text {
            id: timeText
            Layout.alignment: Qt.AlignHCenter
            text: Qt.formatDateTime(clock.date, "hh:mm")
            color: root.textColor
            font.family: root.fontFamily
            font.pixelSize: 96
            font.weight: Font.Bold
            renderType: Text.NativeRendering
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: Qt.formatDateTime(clock.date, "dddd, MMMM d")
            color: root.secondaryColor
            font.family: root.fontFamily
            font.pixelSize: 22
            font.weight: Font.Bold
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: root.context.user
            color: root.dimColor
            font.family: root.fontFamily
            font.pixelSize: 16
        }

        Column {
            id: mediaBlock
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 4
            Layout.bottomMargin: 12
            spacing: 14
            visible: root.hasTrack

            Rectangle {
                id: mediaArt
                width: 200
                height: 200
                radius: 16
                anchors.horizontalCenter: parent.horizontalCenter
                color: root.borderColor
                clip: true

                Image {
                    width: mediaArt.width
                    height: mediaArt.height
                    anchors.centerIn: parent
                    source: root.artUrl
                    fillMode: Image.PreserveAspectCrop
                    smooth: true
                    onStatusChanged: if (status === Image.Error)
                        artFallback.visible = true
                }

                MultiEffect {
                    id: artFallback
                    anchors.centerIn: parent
                    width: 80
                    height: 80
                    source: Image {
                        width: 80
                        height: 80
                        source: Qt.resolvedUrl("./assets/Musical-notes.svg")
                        sourceSize.width: 80
                        sourceSize.height: 80
                    }
                    colorization: 1
                    colorizationColor: root.dimColor
                    visible: root.artUrl === ""
                }
            }

            Row {
                id: mediaRow
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 12

                Column {
                    width: 260
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 4

                    Text {
                        width: parent.width
                        text: root.title || "Unknown Title"
                        color: root.textColor
                        font.family: root.fontFamily
                        font.pixelSize: 20
                        font.weight: Font.Bold
                        elide: Text.ElideRight
                        maximumLineCount: 1
                    }

                    Text {
                        width: parent.width
                        text: root.artist || "Unknown Artist"
                        color: root.secondaryColor
                        font.family: root.fontFamily
                        font.pixelSize: 18
                        elide: Text.ElideRight
                        maximumLineCount: 1
                    }
                }

                Item {
                    id: playButton
                    width: 44
                    height: 44
                    anchors.verticalCenter: parent.verticalCenter

                    MultiEffect {
                        anchors.centerIn: parent
                        width: 28
                        height: 28
                        source: Image {
                            width: 28
                            height: 28
                            source: Qt.resolvedUrl(root.playing ? "./assets/Pause.svg" : "./assets/Play.svg")
                            sourceSize.width: 28
                            sourceSize.height: 28
                        }
                        colorization: 1
                        colorizationColor: root.accentColor
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.player?.togglePlaying()
                    }
                }
            }

            MediaProgress {
                id: progressBar
                width: mediaRow.implicitWidth
                player: root.player
                position: root.pos
                length: root.len
                trackColor: root.borderColor
                fillColor: root.accentColor
            }
        }

        Row {
            id: inputRow
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 24
            spacing: 10

            Rectangle {
                id: passwordField
                width: 300
                height: 44
                radius: 8
                color: Theme.palette.barBg
                border.color: passwordInput.activeFocus ? root.accentColor : root.borderColor
                border.width: 1

                TextInput {
                    id: passwordInput
                    anchors.fill: parent
                    anchors.leftMargin: 14
                    anchors.rightMargin: 14
                    verticalAlignment: Text.AlignVCenter
                    echoMode: TextInput.Password
                    inputMethodHints: Qt.ImhSensitiveData
                    color: root.textColor
                    font.family: root.fontFamily
                    font.pixelSize: 16
                    passwordCharacter: "•"
                    enabled: !root.context.unlockInProgress

                    // Update the context when the box changes, so every monitor
                    // stays in sync.
                    onTextChanged: root.context.currentText = text
                    onAccepted: root.context.tryUnlock()
                }

                // Sync the box back to the context, so typing on one monitor
                // shows up on all of them.
                Connections {
                    target: root.context
                    function onCurrentTextChanged() {
                        passwordInput.text = root.context.currentText;
                    }
                }
            }

            Rectangle {
                id: unlockButton
                width: 90
                height: 44
                radius: 8
                color: root.accentColor
                enabled: !root.context.unlockInProgress && root.context.currentText !== ""

                Rectangle {
                    anchors.fill: parent
                    radius: 8
                    color: "transparent"
                    border.color: Qt.lighter(root.accentColor, 1.4)
                    border.width: 1
                    visible: unlockMouse.containsMouse
                }

                Text {
                    anchors.centerIn: parent
                    text: "Unlock"
                    color: Theme.palette.barBg
                    font.family: root.fontFamily
                    font.pixelSize: 15
                    font.weight: Font.Bold
                }

                MouseArea {
                    id: unlockMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.context.tryUnlock()
                }
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 10
            text: "Incorrect password"
            color: root.errorColor
            font.family: root.fontFamily
            font.pixelSize: 14
            visible: root.context.showFailure
        }
    }

    // Keep the password box focused on whichever surface is currently active.
    Connections {
        target: root.Window.window
        function onActiveChanged() {
            if (root.Window.window.active)
                passwordInput.forceActiveFocus();
        }
    }

    // Refocus after a failed attempt so typing can resume immediately.
    Connections {
        target: root.context
        function onUnlockInProgressChanged() {
            if (!root.context.unlockInProgress)
                passwordInput.forceActiveFocus();
        }
    }
}
