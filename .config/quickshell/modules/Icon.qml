import QtQuick
import QtQuick.Effects

// Reusable colorized SVG icon: a MultiEffect tinted from a single Image.
MultiEffect {
    id: root

    property url icon: ""
    property color color: "transparent"

    source: image
    colorization: 1
    colorizationColor: root.color

    Image {
        id: image
        width: root.width
        height: root.height
        source: root.icon
        sourceSize.width: root.width
        sourceSize.height: root.height
    }
}
