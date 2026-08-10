import QtQuick
import Quickshell
import "./modules"
import "./themes"

ShellRoot {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            id: barWindow
            screen: modelData
            implicitHeight: 50
            anchors {
                top: true
                left: true
                right: true
            }
            color: Theme.palette.barBg

        Item {
            id: bar
            anchors.fill: parent

            Rectangle {
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }
                height: 1
                color: Theme.palette.barBorder
            }

            Media {
                id: mediaCard
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                    leftMargin: 4
                }
            }

            Titles {
                id: titlesCard
                anchors {
                    left: mediaCard.right
                    verticalCenter: parent.verticalCenter
                    leftMargin: 12
                }
                maxWidth: 250
                screenName: modelData.name
            }

            WorkspaceSwitcher {
                id: switcherCard
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
                screenName: modelData.name
            }

            Battery {
                id: batteryCard
                anchors {
                    right: volumeCard.left
                    verticalCenter: parent.verticalCenter
                    rightMargin: 22
                }
            }

            Volume {
                id: volumeCard
                anchors {
                    right: clockCard.left
                    verticalCenter: parent.verticalCenter
                    rightMargin: 32
                }
            }

            Rectangle {
                width: 1
                height: 26
                color: Theme.palette.minimapWindow
                anchors {
                    right: clockCard.left
                    verticalCenter: parent.verticalCenter
                    rightMargin: 14
                }
            }

            VolumeOsd {}

            Clock {
                id: clockCard
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: 16
                }
            }
        }
    }
    }
}
