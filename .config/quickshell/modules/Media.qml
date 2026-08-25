import QtQuick
import Quickshell
import "../themes"

Item {
    id: root

    // Bar window the media popup is anchored to, so it drops below the bar
    // rather than hugging the album art inside it.
    property var anchorWindow: null

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

    NowPlaying {
        id: np
    }

    readonly property int artSize: 42
    readonly property int sliderHeight: artSize

    width: np.hasTrack ? implicitWidth : 0
    height: np.hasTrack ? implicitHeight : 0
    visible: np.hasTrack

    function recalcPopupHeight() {
        if (!cardCol)
            return;
        root.popupHeight = cardCol.implicitHeight + 34;
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
                id: artImage
                // zoomed in ~43% so ~15% is cropped off each side
                width: art.width * 1.428
                height: art.height * 1.428
                anchors.centerIn: parent
                source: np.artUrl
                fillMode: Image.PreserveAspectCrop
                smooth: true
            }

            Icon {
                id: fallback
                anchors.centerIn: parent
                width: 20
                height: 20
                icon: Qt.resolvedUrl("../assets/Musical-notes.svg")
                color: root.dimTextColor
                visible: np.artUrl === "" || artImage.status === Image.Error
            }

            MouseArea {
                id: artMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onEntered: {
                    hideTimer.stop();
                    if (np.hasTrack)
                        PopupManager.open(popup);
                }
                onExited: hideTimer.start()
                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton)
                        np.player?.togglePlaying();
                    else if (mouse.button === Qt.MiddleButton) {
                        if (popup.visible)
                            PopupManager.close(popup);
                        else
                            PopupManager.open(popup);
                        hideTimer.stop();
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
                height: parent.height * (np.len > 0 ? np.pos / np.len : 0)
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
        // Below the bar's bottom edge, 8px off it and the screen's left edge.
        anchor.window: root.anchorWindow
        anchor.rect.x: root.anchorWindow ? 8 : 0
        anchor.rect.y: root.anchorWindow ? root.anchorWindow.height + 8 : 0
        implicitWidth: 300
        implicitHeight: root.popupHeight

        Rectangle {
            id: cardBody
            anchors.fill: parent
            color: root.cardBg
            border.color: root.cardBorder
            border.width: 1
            radius: 4

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
                        source: np.artUrl
                        fillMode: Image.PreserveAspectCrop
                        smooth: true
                    }

                    Icon {
                        anchors.centerIn: parent
                        width: 56
                        height: 56
                        icon: Qt.resolvedUrl("../assets/Musical-notes.svg")
                        color: root.dimTextColor
                        visible: np.artUrl === ""
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: np.title || "Unknown Title"
                    font.family: Theme.palette.fontFamily
                    font.pixelSize: 15
                    font.weight: Font.Bold
                    color: root.textColor
                    wrapMode: Text.WordWrap
                    maximumLineCount: 2
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: np.artist || "Unknown Artist"
                    font.family: Theme.palette.fontFamily
                    font.pixelSize: 13
                    color: Theme.palette.textSecondary
                    elide: Text.ElideRight
                    maximumLineCount: 1
                }

                MediaProgress {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - 40
                    player: np.player
                    position: np.pos
                    length: np.len
                    trackColor: root.cardBorder
                    fillColor: root.thumbColor
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 22

                    Repeater {
                        model: [
                            {
                                icon: "Play-back",
                                action: "prev"
                            },
                            {
                                icon: "",
                                action: "toggle"
                            },
                            {
                                icon: "Play-forward",
                                action: "next"
                            },
                        ]

                        delegate: Item {
                            id: btn
                            required property var modelData
                            width: 30
                            height: 30

                            readonly property string resolvedIcon: modelData.icon === "" ? (np.playing ? "Pause" : "Play") : modelData.icon

                            Icon {
                                anchors.centerIn: parent
                                width: 22
                                height: 22
                                icon: Qt.resolvedUrl("../assets/" + btn.resolvedIcon + ".svg")
                                color: root.textColor
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (modelData.action === "prev")
                                        np.player?.previous();
                                    else if (modelData.action === "next")
                                        np.player?.next();
                                    else
                                        np.player?.togglePlaying();
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
        onTriggered: PopupManager.close(popup)
    }
}
