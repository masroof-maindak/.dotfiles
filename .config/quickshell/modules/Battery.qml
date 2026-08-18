import QtQuick
import Quickshell.Services.UPower
import "../themes"

Item {
    id: root

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
}
