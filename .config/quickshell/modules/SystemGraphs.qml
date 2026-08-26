import QtQuick
import "../themes"
import "utils.js" as Utils

// CPU / RAM / network utilisation rows. The sparkline spans all remaining
// width; the current value is overlaid on its top-right corner.
Column {
    id: root

    spacing: 8

    component GraphRow: Item {
        id: row

        property string label
        property color graphColor
        property var series
        property string valueText

        width: parent.width
        height: 28

        Text {
            id: label
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
            text: row.label
            font.family: Theme.palette.fontFamily
            font.pixelSize: 13
            font.weight: Font.Bold
            color: Theme.palette.textDim
        }

        Item {
            id: graphArea
            anchors {
                left: label.right
                leftMargin: 10
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }

            Sparkline {
                anchors.fill: parent
                lineColor: row.graphColor
                values: row.series
            }

            Text {
                anchors {
                    right: parent.right
                    top: parent.top
                }
                text: row.valueText
                font.family: Theme.palette.fontFamily
                font.pixelSize: 13
                font.weight: Font.Bold
                color: row.graphColor
            }
        }
    }

    GraphRow {
        width: parent.width
        label: "CPU"
        graphColor: Theme.palette.accent
        series: SystemStats.cpuHistory
        valueText: Math.round(SystemStats.cpuUsage * 100) + "%"
    }

    GraphRow {
        width: parent.width
        label: "RAM"
        graphColor: Theme.palette.blue
        series: SystemStats.ramHistory
        valueText: Math.round(SystemStats.ramUsage * 100) + "%"
    }

    GraphRow {
        width: parent.width
        label: "NET"
        graphColor: Theme.palette.magenta
        series: SystemStats.netHistory
        valueText: "RX:" + Utils.formatRate(SystemStats.netDownRate) + " TX:" + Utils.formatRate(SystemStats.netUpRate)
    }
}
