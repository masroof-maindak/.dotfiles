import QtQuick
import QtQuick.Effects
import Quickshell.Services.UPower
import "../themes"

Item {
    id: root

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight
    width: implicitWidth
    height: implicitHeight

    property color textColor: Theme.palette.text
    property color lowBatteryColor: Theme.palette.red
    property color warningColor: Theme.palette.accent
    property int iconSize: 25
    property int fontHeight: 14

    readonly property var battery: UPower.displayDevice.ready ? UPower.displayDevice : null

    readonly property int pct: battery?.percentage != null ? Math.round(battery.percentage * 100) : -1
    readonly property bool present: battery?.isPresent ?? false
    readonly property bool charging: battery?.state === UPowerDeviceState.Charging || battery?.state === UPowerDeviceState.FullyCharged || battery?.state === UPowerDeviceState.Unknown

    // Red when critically low, yellow when getting low, normal otherwise.
    readonly property color batteryColor: {
        if (!present || charging) return textColor
        if (pct < 10) return lowBatteryColor
        if (pct < 25) return warningColor
        return textColor
    }

    readonly property string iconFile: {
        if (!present)
            return "../assets/Battery-dead.svg";
        if (charging)
            return "../assets/Battery-charging.svg";
        return "../assets/Battery-half.svg";
    }

    Row {
        id: content
        spacing: 6
        anchors.verticalCenter: parent.verticalCenter

        MultiEffect {
            width: root.iconSize
            height: root.iconSize
            anchors.verticalCenter: parent.verticalCenter
            source: Image {
                width: root.iconSize
                height: root.iconSize
                source: Qt.resolvedUrl(root.iconFile)
                sourceSize.width: root.iconSize
                sourceSize.height: root.iconSize
            }
            colorization: 1
            colorizationColor: root.batteryColor
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
