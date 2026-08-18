pragma Singleton
import QtQuick

QtObject {
    readonly property string fontFamily: "Roboto Black"
    readonly property color barBg: "#242015"
    readonly property color barBorder: "#3a3124"
    readonly property color text: "#ebe0bb"
    readonly property color textDim: "#5f4e41"
    readonly property color textSecondary: "#b8a58c"
    readonly property color accent: "#db930d"
    readonly property color green: "#6f682c"
    readonly property color pink: "#d45d67"
    readonly property color blue: "#A8663C"

    readonly property color red: "#a93b5c"
    readonly property color magenta: "#91506c"

    readonly property color workspaceIdle: "#4d3f32"
    readonly property color workspaceActive: "#5f4e41"
    readonly property color workspaceFocused: "#ebe0bb"
    readonly property color workspaceUrgent: "#a93b5c"

    readonly property color minimapBg: "#2c241a"
    readonly property color minimapWindow: "#4d3f32"

    readonly property variant workspaceColors: [red, accent, green, blue, magenta, pink]
}
