import QtQuick
import Quickshell
import Quickshell.Services.UPower
import "../themes"

Item {
    id: root

    // Bar window the battery popup is anchored to, so it drops below the bar.
    property var anchorWindow: null

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    property color textColor: Theme.palette.text
    property color lowBatteryColor: Theme.palette.red
    property color warningColor: Theme.palette.accent
    property color highColor: Theme.palette.green
    property int iconSize: 21
    property int fontHeight: 14

    readonly property var battery: UPower.displayDevice.ready ? UPower.displayDevice : null

    readonly property int pct: battery?.percentage != null ? Math.round(battery.percentage * 100) : -1
    readonly property bool present: battery?.isPresent ?? false
    readonly property bool charging: battery?.state === UPowerDeviceState.Charging || battery?.state === UPowerDeviceState.FullyCharged || battery?.state === UPowerDeviceState.Unknown

    // Red when critically low, yellow when getting low, normal otherwise.
    readonly property color batteryColor: {
        if (!present)
            return textColor;
        if (charging && pct > 85)
            return highColor;
        if (pct < 10)
            return lowBatteryColor;
        if (pct < 25)
            return warningColor;
        return textColor;
    }

    readonly property string iconFile: {
        if (!root.present)
            return "";
        const base = root.charging ? "Battery-charging-" : "Battery-";
        return "../assets/" + base + root.level + ".svg";
    }

    // Rounded to the nearest 10% within [10, 100], matching the icon set.
    readonly property int level: Math.max(10, Math.round(root.pct / 10) * 10)

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

    visible: root.present

    Row {
        id: content
        spacing: 6
        anchors.verticalCenter: parent.verticalCenter

        Icon {
            width: root.iconSize
            height: root.iconSize
            anchors.verticalCenter: parent.verticalCenter
            icon: Qt.resolvedUrl(root.iconFile)
            color: root.batteryColor
        }

        Text {
            text: root.pct >= 0 ? root.pct : "—"
            font.family: Theme.palette.fontFamily
            font.pixelSize: root.fontHeight
            font.weight: Font.Bold
            color: root.batteryColor
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: popup.visible = true
        onExited: hideTimer.start()
    }

    PopupWindow {
        id: popup
        visible: false
        color: "transparent"
        anchor.window: root.anchorWindow
        // Centered under the battery, clamped 8px from either screen edge and
        // 8px below the bar's bottom edge.
        anchor.rect.x: root.anchorWindow ? Math.max(8, Math.min(root.anchorWindow.width - width - 8, root.x + root.width / 2 - width / 2)) : 0
        anchor.rect.y: root.anchorWindow ? root.anchorWindow.height + 8 : 0
        implicitWidth: 280
        implicitHeight: cardCol.implicitHeight + 40

        Rectangle {
            anchors.fill: parent
            radius: 4
            color: Theme.palette.barBg
            border.color: Theme.palette.barBorder
            border.width: 1

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: hideTimer.stop()
                onExited: hideTimer.start()
            }

            Column {
                id: cardCol
                anchors.fill: parent
                anchors.margins: 20
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
                                    color: dev.low ? root.lowBatteryColor : Theme.palette.accent
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
                                color: dev.low ? root.lowBatteryColor : Theme.palette.textSecondary
                            }
                        }
                    }
                }
            }
        }
    }

    Timer {
        id: hideTimer
        interval: 150
        onTriggered: popup.visible = false
    }
}
