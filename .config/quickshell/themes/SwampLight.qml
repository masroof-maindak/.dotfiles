pragma Singleton
import QtQuick

QtObject {
    readonly property string fontFamily: "Roboto Black"
    readonly property color barBg: "#f1e3d1"
    readonly property color barBorder: "#ddcebc"
    readonly property color text: "#64513e"
    readonly property color textDim: "#b5a492"
    readonly property color textSecondary: "#8C7B68"
    readonly property color accent: "#d09700"
    readonly property color green: "#8d8851"
    readonly property color pink: "#bf7979"
    readonly property color blue: "#75858c"
    readonly property color red: "#a73838"
    readonly property color magenta: "#9E5581"

    readonly property color workspaceIdle: "#c9b9a7"
    readonly property color workspaceActive: "#b5a492"
    readonly property color workspaceFocused: "#64513e"
    readonly property color workspaceUrgent: "#a73838"

    readonly property color minimapBg: "#e6d8c4"
    readonly property color minimapWindow: "#d3c2ae"

    readonly property variant workspaceColors: [red, accent, green, blue, magenta, pink]
}
