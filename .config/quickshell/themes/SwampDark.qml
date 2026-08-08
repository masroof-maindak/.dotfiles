import QtQuick

pragma Singleton
QtObject {
    readonly property color barBg: "#242015"
    readonly property color barBorder: "#3a3124"
    readonly property string fontFamily: "JetBrains Mono"
    readonly property color text: "#ebe0bb"
    readonly property color textDim: "#5f4e41"
    readonly property color textSecondary: "#b8a58c"
    readonly property color accent: "#db930d"
    readonly property color green: "#7a7653"
    readonly property color pink: "#c1666b"
    readonly property color blue: "#61a0a8"
    readonly property color red: "#a82d56"
    readonly property color magenta: "#91506c"

  readonly property color workspaceIdle: "#4d3f32"
  readonly property color workspaceActive: "#5f4e41"
  readonly property color workspaceFocused: "#ebe0bb"
  readonly property color workspaceUrgent: "#a82d56"

  readonly property color minimapBg: "#2c241a"
  readonly property color minimapWindow: "#4d3f32"

  readonly property variant workspaceColors: [red, accent, green, blue, magenta, pink]
}