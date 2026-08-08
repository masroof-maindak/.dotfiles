import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Services.Mpris
import "../themes"

Item {
    id: root

    // Popup card height, driven by the card content so a short title (single
    // line) hugs the buttons instead of leaving dead space.
    property int popupHeight: 370

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    property color cardBg: Theme.palette.barBg
    property color cardBorder: Theme.palette.barBorder
    property color textColor: Theme.palette.text
    property color dimTextColor: Theme.palette.textDim
    property color trackColor: Theme.palette.barBorder
    property color thumbColor: Theme.palette.accent

    // Player selection is fully reactive: the MPRIS object model reports
    // player additions/removals, and each player reports play-state changes.
    property var player: null

    Connections {
        target: Mpris.players
        function onValuesChanged() { root._reselect() }
    }

    Connections {
        target: root.player
        function onIsPlayingChanged() { root._reselect() }
    }

    Component.onCompleted: root._reselect()

    function _reselect() {
        let playing = null
        let last = null
        for (const p of Mpris.players.values) {
            last = p
            if (p.isPlaying) playing = p
        }
        root.player = playing ?? last
    }

    readonly property bool hasTrack: !!player
        && (player.isPlaying || player.length > 0)

    readonly property string title: player?.trackTitle ?? ""
    readonly property string artist: player?.trackArtist ?? ""
    readonly property string artUrl: player?.trackArtUrl ?? ""
    readonly property real pos: player?.position ?? 0
    readonly property real len: player?.length ?? 0
    readonly property bool playing: player?.isPlaying ?? false

    readonly property int artSize: 42
    readonly property int sliderHeight: artSize

    width: hasTrack ? implicitWidth : 0
    height: hasTrack ? implicitHeight : 0
    visible: hasTrack

    // MPRIS doesn't push position continuously, so we emit the change
    // ourselves to keep the progress sliders moving (only while playing).
    Timer {
        interval: 200
        repeat: true
        running: root.player?.isPlaying ?? false
        onTriggered: root.player?.positionChanged()
    }

    function recalcPopupHeight() {
        if (typeof cardCol === "undefined" || cardCol === null) return
        root.popupHeight = cardCol.implicitHeight + 34
    }

    Row {
        id: content
        spacing: 4
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            id: art
            width: root.artSize
            height: root.artSize
            radius: 3
            color: root.trackColor
            clip: true

            Image {
                // zoomed in ~43% so ~15% is cropped off each side
                width: art.width * 1.428
                height: art.height * 1.428
                anchors.centerIn: parent
                source: root.artUrl
                fillMode: Image.PreserveAspectCrop
                onStatusChanged: if (status === Image.Error) fallback.visible = true
                smooth: true
            }

            MultiEffect {
                id: fallback
                anchors.centerIn: parent
                width: 20
                height: 20
                source: Image {
                    width: 20
                    height: 20
                    source: Qt.resolvedUrl("../assets/Musical-notes.svg")
                    sourceSize.width: 20
                    sourceSize.height: 20
                }
                colorization: 1
                colorizationColor: root.dimTextColor
                visible: root.artUrl === ""
            }

            MouseArea {
                id: artMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onEntered: {
                    hideTimer.stop()
                    if (root.hasTrack) popup.visible = true
                }
                onExited: hideTimer.start()
                onClicked: (mouse) => {
                    if (mouse.button === Qt.LeftButton) root.player?.togglePlaying()
                    else if (mouse.button === Qt.MiddleButton) {
                        popup.visible = !popup.visible
                        hideTimer.stop()
                    }
                }
            }
        }

        Rectangle {
            id: slider
            width: 5
            height: root.sliderHeight
            color: root.trackColor
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                height: parent.height * (root.len > 0 ? root.pos / root.len : 0)
                width: parent.width
                color: root.thumbColor
                anchors.bottom: parent.bottom
            }
        }
    }

    // card shown when hovering the album art
    PopupWindow {
        id: popup
        visible: false
        color: "transparent"
        anchor.item: art
        anchor.rect.x: art.width + 8
        anchor.rect.y: art.height + 8
        implicitWidth: 300
        implicitHeight: root.popupHeight

        Rectangle {
            id: cardBody
            anchors.fill: parent
            color: root.cardBg
            border.color: root.cardBorder
            border.width: 1
            radius: 10

            MouseArea {
                id: popupHover
                anchors.fill: parent
                hoverEnabled: true
                onEntered: hideTimer.stop()
                onExited: hideTimer.start()
            }

Column {
                id: cardCol
                anchors.fill: parent
                anchors.margins: 14
                anchors.bottomMargin: 20
                spacing: 10
                onImplicitHeightChanged: root.recalcPopupHeight()
                Component.onCompleted: root.recalcPopupHeight()

                Rectangle {
                    id: cardArt
                    width: 220
                    height: 220
                    radius: 8
                    color: root.trackColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    clip: true

                    Image {
                        // full-size, unzoomed
                        anchors.fill: parent
                        source: root.artUrl
                        fillMode: Image.PreserveAspectCrop
                        smooth: true
                    }

                    MultiEffect {
                        anchors.centerIn: parent
                        width: 56
                        height: 56
                        source: Image {
                            width: 56
                            height: 56
                            source: Qt.resolvedUrl("../assets/Musical-notes.svg")
                            sourceSize.width: 56
                            sourceSize.height: 56
                        }
                        colorization: 1
                        colorizationColor: root.dimTextColor
                        visible: root.artUrl === ""
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: root.title || "Unknown Title"
                    font.family: Theme.palette.fontFamily
                    font.pixelSize: 15
                    font.weight: Font.Bold
                    color: root.textColor
                    wrapMode: Text.WordWrap
                    maximumLineCount: 2
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: root.artist || "Unknown Artist"
                    font.family: Theme.palette.fontFamily
                    font.pixelSize: 13
                    color: Theme.palette.textSecondary
                    elide: Text.ElideRight
                    maximumLineCount: 1
                }

                Rectangle {
                    id: bigSlider
                    width: parent.width
                    height: 16
                    color: root.cardBorder

                    Rectangle {
                        width: parent.width * (root.len > 0 ? root.pos / root.len : 0)
                        height: parent.height
                        color: root.thumbColor
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: (mouse) => {
                            if (!root.player || root.len <= 0) return
                            const fraction = mouse.x / width
                            const target = fraction * root.len
                            root.player.seek(target - root.pos)
                        }
                    }
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 22

                    Repeater {
                        model: [
                            { icon: "Play-back", action: "prev" },
                            { icon: "", action: "toggle" },
                            { icon: "Play-forward", action: "next" },
                        ]

                        delegate: Item {
                            id: btn
                            required property var modelData
                            width: 30
                            height: 30

                            readonly property string resolvedIcon: modelData.icon === ""
                                ? (root.playing ? "Pause" : "Play")
                                : modelData.icon

                            MultiEffect {
                                anchors.centerIn: parent
                                width: 22
                                height: 22
                                source: Image {
                                    width: 22
                                    height: 22
                                    source: Qt.resolvedUrl("../assets/" + btn.resolvedIcon + ".svg")
                                    sourceSize.width: 22
                                    sourceSize.height: 22
                                }
                                colorization: 1
                                colorizationColor: root.textColor
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (modelData.action === "prev") root.player?.previous()
                                    else if (modelData.action === "next") root.player?.next()
                                    else root.player?.togglePlaying()
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Timer {
        id: hideTimer
        interval: 200
        onTriggered: popup.visible = false
    }
}
