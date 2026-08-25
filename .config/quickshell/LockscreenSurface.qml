import QtQuick
import QtQuick.Layouts
import Quickshell
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

    // Hover catchers for the indicator popups. Declared before the
    // indicators so their own click handling stays on top; those don't
    // enable hover, so these still receive it.
    MouseArea {
        anchors.fill: lockVolume
        hoverEnabled: true
        onEntered: PopupManager.open(volCard)
        onExited: volHide.start()
    }

    MouseArea {
        anchors.fill: lockBattery
        hoverEnabled: true
        onEntered: PopupManager.open(batCard)
        onExited: batHide.start()
    }

    Volume {
        id: lockVolume
        anchors {
            right: parent.right
            top: parent.top
            margins: 16
        }
        iconSize: 21
        popupEnabled: false
    }

    Battery {
        id: lockBattery
        anchors {
            right: lockVolume.left
            verticalCenter: lockVolume.verticalCenter
            rightMargin: 18
        }
        popupEnabled: false
    }

    // The cards render directly inside the lock surface: a session-lock
    // surface cannot host child popup windows.
    Rectangle {
        id: volCard

        visible: false
        z: 1
        x: Math.max(8, Math.min(parent.width - width - 8, lockVolume.x + lockVolume.width / 2 - width / 2))
        y: lockVolume.y + lockVolume.height + 8
        width: 300
        height: mixerContent.implicitHeight + 40
        radius: 4
        color: Theme.palette.barBg
        border.color: Theme.palette.barBorder
        border.width: 1

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: volHide.stop()
            onExited: volHide.start()
        }

        MixerContent {
            id: mixerContent
            anchors.centerIn: parent
            width: 260
        }
    }

    Rectangle {
        id: batCard

        visible: false
        z: 1
        x: Math.max(8, Math.min(parent.width - width - 8, lockBattery.x + lockBattery.width / 2 - width / 2))
        y: lockVolume.y + lockVolume.height + 8
        width: 280
        height: batteryContent.implicitHeight + 40
        radius: 4
        color: Theme.palette.barBg
        border.color: Theme.palette.barBorder
        border.width: 1

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: batHide.stop()
            onExited: batHide.start()
        }

        BatteryContent {
            id: batteryContent
            anchors.centerIn: parent
            width: 240
        }
    }

    Timer {
        id: volHide
        interval: 150
        onTriggered: PopupManager.close(volCard)
    }

    Timer {
        id: batHide
        interval: 150
        onTriggered: PopupManager.close(batCard)
    }

    readonly property color textColor: Theme.palette.text
    readonly property color secondaryColor: Theme.palette.textSecondary
    readonly property color dimColor: Theme.palette.textDim
    readonly property color accentColor: Theme.palette.accent
    readonly property color borderColor: Theme.palette.barBorder
    readonly property color errorColor: Theme.palette.red
    readonly property string fontFamily: "Roboto"

    NowPlaying {
        id: np
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
            visible: np.hasTrack

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
                    source: np.artUrl
                    fillMode: Image.PreserveAspectCrop
                    smooth: true
                    onStatusChanged: if (status === Image.Error)
                        artFallback.visible = true
                }

                Icon {
                    id: artFallback
                    anchors.centerIn: parent
                    width: 80
                    height: 80
                    icon: Qt.resolvedUrl("./assets/Musical-notes.svg")
                    color: root.dimColor
                    visible: np.artUrl === ""
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
                        text: np.title || "Unknown Title"
                        color: root.textColor
                        font.family: root.fontFamily
                        font.pixelSize: 20
                        font.weight: Font.Bold
                        elide: Text.ElideRight
                        maximumLineCount: 1
                    }

                    Text {
                        width: parent.width
                        text: np.artist || "Unknown Artist"
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

                    Icon {
                        anchors.centerIn: parent
                        width: 28
                        height: 28
                        icon: Qt.resolvedUrl(np.playing ? "./assets/Pause.svg" : "./assets/Play.svg")
                        color: root.accentColor
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: np.player?.togglePlaying()
                    }
                }
            }

            MediaProgress {
                id: progressBar
                width: mediaRow.implicitWidth
                player: np.player
                position: np.pos
                length: np.len
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
