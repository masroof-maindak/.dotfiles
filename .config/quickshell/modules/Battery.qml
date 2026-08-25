import QtQuick
import Quickshell
import Quickshell.Services.UPower
import "../themes"
import "utils.js" as Utils

Item {
    id: root

    // Bar window the battery popup is anchored to, so it drops below the bar.
    property var anchorWindow: null

    // Off where child popup windows can't exist (e.g. the lockscreen), so
    // hover falls through to an external handler instead.
    property bool popupEnabled: true

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

    readonly property color batteryColor: !root.present ? root.textColor : Utils.batteryColor(root.pct, root.charging, highColor, warningColor, lowBatteryColor, textColor)

    readonly property string iconFile: {
        if (!root.present)
            return "";
        const base = root.charging ? "Battery-charging-" : "Battery-";
        return "../assets/" + base + root.level + ".svg";
    }

    // Rounded to the nearest 10% within [10, 100], matching the icon set.
    readonly property int level: Math.max(10, Math.round(root.pct / 10) * 10)

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
        hoverEnabled: root.popupEnabled
        onEntered: PopupManager.open(popup)
        onExited: hideTimer.start()
    }

    // Charge state and connected-device levels, shown on hover.
    PopupWindow {
        id: popup
        visible: false
        color: "transparent"
        anchor.window: root.anchorWindow
        // Centered under the battery icon, clamped 8px from either screen edge
        // and 8px below the bar's bottom edge.
        anchor.rect.x: root.anchorWindow ? Math.max(8, Math.min(root.anchorWindow.width - width - 8, root.x + root.width / 2 - width / 2)) : 0
        anchor.rect.y: root.anchorWindow ? root.anchorWindow.height + 8 : 0
        implicitWidth: 280
        implicitHeight: batteryContent.implicitHeight + 40

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

            BatteryContent {
                id: batteryContent
                anchors.centerIn: parent
                width: 240
            }
        }
    }

    Timer {
        id: hideTimer
        interval: 150
        onTriggered: PopupManager.close(popup)
    }
}
