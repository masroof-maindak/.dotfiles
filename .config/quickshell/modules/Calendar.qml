import QtQuick
import "../themes"

// Month calendar grid for the given date: a weekday header above a
// Monday-first day grid, with today's cell highlighted.
Item {
    id: root

    required property var date

    readonly property int cellW: 32
    readonly property int cellH: 26

    readonly property int _year: parseInt(Qt.formatDate(root.date, "yyyy"))
    readonly property int _month: parseInt(Qt.formatDate(root.date, "M"))
    readonly property int _lead: (new Date(root._year, root._month - 1, 1).getDay() + 6) % 7
    readonly property int _days: new Date(root._year, root._month, 0).getDate()
    readonly property int _today: parseInt(Qt.formatDate(root.date, "d"))

    // Blank cells pad the weeks before day 1 and after the last day.
    readonly property var grid: {
        const cells = [];
        for (let i = 0; i < root._lead; i++)
            cells.push(0);
        for (let d = 1; d <= root._days; d++)
            cells.push(d);
        while (cells.length % 7 !== 0)
            cells.push(0);
        return cells;
    }

    readonly property int _rows: Math.ceil(root.grid.length / 7)

    implicitWidth: root.cellW * 7
    implicitHeight: column.implicitHeight

    Column {
        id: column
        width: parent.width
        spacing: 6

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDate(root.date, "MMMM yyyy")
            font.family: Theme.palette.fontFamily
            font.pixelSize: 15
            font.weight: Font.Bold
            color: Theme.palette.text
        }

        Row {
            id: week
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                model: ["M", "T", "W", "T", "F", "S", "S"]
                delegate: Item {
                    width: root.cellW
                    height: root.cellH

                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        font.family: Theme.palette.fontFamily
                        font.pixelSize: 11
                        color: Theme.palette.accent
                    }
                }
            }
        }

        Grid {
            columns: 7
            width: root.cellW * 7
            height: root._rows * root.cellH

            Repeater {
                model: root.grid
                delegate: Rectangle {
                    width: root.cellW
                    height: root.cellH
                    radius: 2
                    color: modelData === root._today ? Theme.palette.accent : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: modelData === 0 ? "" : modelData
                        font.family: Theme.palette.fontFamily
                        font.pixelSize: 12
                        font.weight: modelData === root._today ? Font.Bold : Font.Normal
                        color: modelData === 0 ? "transparent" : (modelData === root._today ? Theme.palette.barBg : Theme.palette.text)
                    }
                }
            }
        }
    }
}