import QtQuick

pragma Singleton
QtObject {
    // Active colour scheme follows darkman's current mode (light/dark),
    // streamed by the Darkman singleton.
    readonly property var palette: Darkman.dark ? SwampDark : SwampLight
}
