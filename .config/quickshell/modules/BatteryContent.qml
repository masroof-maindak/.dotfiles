import QtQuick
import Quickshell.Services.UPower
import "../themes"
import "utils.js" as Utils

// Shared battery popup contents: charge header plus peripheral device
// levels. The host supplies the width.
Item {
    id: root

    property color lowColor: Theme.palette.red

    readonly property var battery: UPower.displayDevice.ready ? UPower.displayDevice : null
    readonly property int pct: battery?.percentage != null ? Math.round(battery.percentage * 100) : -1
    readonly property bool charging: battery?.state === UPowerDeviceState.Charging || battery?.state === UPowerDeviceState.FullyCharged || battery?.state === UPowerDeviceState.Unknown
    readonly property color batteryColor: Utils.batteryColor(root.pct, root.charging, Theme.palette.green, Theme.palette.accent, root.lowColor, Theme.palette.text)

    function formatRemaining(sec) {
        if (!sec || sec <= 0)
            return "";
        const h = Math.floor(sec / 3600);
        const m = Math.round((sec % 3600) / 60);
        if (h === 0 && m === 0)
            return "";
        return h > 0 ? h + "h " + m + "m" : m + "m";
    }

    readonly property string stateLabel: {
        if (root.pct < 0)
            return "No battery";
        const state = root.battery?.state;
        if (state === UPowerDeviceState.Charging)
            return "Charging";
        if (state === UPowerDeviceState.Discharging)
            return "Discharging";
        if (state === UPowerDeviceState.FullyCharged)
            return "Fully charged";
        return "On battery";
    }

    // e.g. "42m until full" or "1h 12m remaining"; empty when unknown.
    readonly property string timeLine: {
        const state = root.battery?.state;
        if (state === UPowerDeviceState.Charging) {
            const t = root.formatRemaining(root.battery.timeToFull);
            return t ? t + " until full" : "";
        }
        if (state === UPowerDeviceState.Discharging) {
            const t = root.formatRemaining(root.battery.timeToEmpty);
            return t ? t + " remaining" : "";
        }
        return "";
    }

    implicitHeight: column.implicitHeight

    Column {
        id: column
        anchors.fill: parent
        spacing: 14

        Row {
            spacing: 12

            Text {
                text: root.pct >= 0 ? root.pct + "%" : "—"
                font.family: Theme.palette.fontFamily
                font.pixelSize: 26
                font.weight: Font.Bold
                color: root.batteryColor
                anchors.verticalCenter: parent.verticalCenter
            }

            Column {
                spacing: 2
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    text: root.stateLabel
                    font.family: Theme.palette.fontFamily
                    font.pixelSize: 15
                    color: Theme.palette.textSecondary
                }

                Text {
                    text: root.timeLine
                    visible: root.timeLine !== ""
                    font.family: Theme.palette.fontFamily
                    font.pixelSize: 13
                    color: Theme.palette.textDim
                }
            }
        }

        Column {
            id: deviceCol
            width: parent.width
            spacing: 10

            Repeater {
                model: UPower.devices

                delegate: Item {
                    id: dev

                    required property var modelData

                    // Peripherals only: skip the laptop battery, line
                    // power, and devices that never reported a level.
                    readonly property bool peripheral: modelData.ready && !modelData.isLaptopBattery && modelData.type !== UPowerDeviceType.LinePower && modelData.type !== UPowerDeviceType.Battery
                    readonly property int level: Math.round(modelData.percentage * 100)
                    readonly property string name: modelData.model || modelData.nativePath.split("/").pop()
                    readonly property bool low: level < 15

                    visible: peripheral && level >= 0 && level <= 100
                    width: parent.width
                    height: visible ? Math.max(nameText.implicitHeight, 16) : 0

                    Text {
                        id: nameText
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - 120
                        elide: Text.ElideRight
                        text: dev.name
                        font.family: Theme.palette.fontFamily
                        font.pixelSize: 15
                        color: Theme.palette.text
                    }

                    Rectangle {
                        id: track
                        anchors.right: pctText.left
                        anchors.rightMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                        width: 80
                        height: 5
                        radius: 2
                        color: Theme.palette.barBorder

                        Rectangle {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: parent.width * dev.level / 100
                            radius: 2
                            color: dev.low ? root.lowColor : Theme.palette.accent
                        }
                    }

                    Text {
                        id: pctText
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        text: dev.level + "%"
                        font.family: Theme.palette.fontFamily
                        font.pixelSize: 14
                        font.weight: Font.Bold
                        color: dev.low ? root.lowColor : Theme.palette.textSecondary
                    }
                }
            }
        }
    }
}
