import QtQuick
import QtQuick.Effects
import Quickshell
import "./themes"

// Swamp-themed replacement for the default config reload toast.
Scope {
    id: root

    property bool failed: false
    property string errorString: ""

    // Extra canvas around the card so the drop shadow isn't clipped by
    // the window edges.
    readonly property int shadowMargin: 24

    Connections {
        target: Quickshell

        function onReloadCompleted() {
            Quickshell.inhibitReloadPopup();
            root.failed = false;
            root.errorString = "";
            popupLoader.loading = true;
        }

        function onReloadFailed(error: string) {
            Quickshell.inhibitReloadPopup();
            // Restart from a clean state if a popup is already up.
            popupLoader.active = false;

            root.failed = true;
            root.errorString = error;
            popupLoader.loading = true;
        }
    }

    // The popup is only ever needed right after a reload.
    LazyLoader {
        id: popupLoader

        PanelWindow {
            id: popup

            anchors {
                top: true
                left: true
            }

            margins {
                top: 25
                left: 25
            }

            implicitWidth: shadowWrap.width
            implicitHeight: shadowWrap.height
            color: "transparent"

            Item {
                id: shadowWrap

                implicitWidth: card.width + root.shadowMargin * 2
                implicitHeight: card.height + root.shadowMargin * 2

                MultiEffect {
                    anchors.fill: card
                    source: card
                    shadowEnabled: true
                    shadowBlur: 0.6
                    shadowVerticalOffset: 4
                    shadowColor: "#99000000"
                }

                Rectangle {
                    id: card

                    anchors.centerIn: parent

                    radius: 0
                    color: Theme.palette.barBg
                    border.color: root.failed ? Theme.palette.red : Theme.palette.barBorder
                    border.width: 1

                    implicitWidth: Math.max(360, Math.min(540, layout.implicitWidth + 48))
                    implicitHeight: layout.implicitHeight + 52

                    MouseArea {
                        id: mouseArea

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: popupLoader.active = false
                    }

                    Column {
                        id: layout

                        anchors {
                            top: parent.top
                            topMargin: 18
                            left: parent.left
                            leftMargin: 24
                            right: parent.right
                            rightMargin: 24
                        }

                        spacing: 5

                        Text {
                            text: root.failed ? "Reload failed" : "Config reloaded"
                            font.family: Theme.palette.fontFamily
                            font.pixelSize: 17
                            font.weight: Font.Bold
                            color: root.failed ? Theme.palette.red : Theme.palette.text
                        }

                        Text {
                            width: parent.width
                            visible: root.errorString !== ""
                            text: root.errorString
                            font.family: Theme.palette.fontFamily
                            font.pixelSize: 14
                            color: Theme.palette.textSecondary
                            wrapMode: Text.WrapAnywhere
                        }
                    }

                    // Drains to show how long until the popup dismisses itself.
                    Rectangle {
                        id: bar

                        anchors {
                            bottom: parent.bottom
                            left: parent.left
                        }

                        radius: 0
                        color: root.failed ? Theme.palette.red : Theme.palette.green
                        height: 8
                        width: card.width

                        PropertyAnimation {
                            id: anim

                            target: bar
                            property: "width"
                            from: card.width
                            to: 0
                            duration: root.failed ? 10000 : 4000
                            onFinished: popupLoader.active = false
                            paused: mouseArea.containsMouse
                        }

                        Component.onCompleted: anim.start()
                    }
                }
            }
        }
    }
}
