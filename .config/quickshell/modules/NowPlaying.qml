import QtQuick
import Quickshell.Services.Mpris

Item {
    id: root

    // Player selection is fully reactive: the MPRIS object model reports
    // player additions/removals, and each player reports play-state changes.
    property var player: null

    Connections {
        target: Mpris.players
        function onValuesChanged() {
            root._reselect();
        }
    }

    Connections {
        target: root.player
        function onIsPlayingChanged() {
            root._reselect();
        }
    }

    Component.onCompleted: root._reselect()

    function _reselect() {
        let playing = null;
        let last = null;
        for (const p of Mpris.players.values) {
            last = p;
            if (p.isPlaying)
                playing = p;
        }
        root.player = playing ?? last;
    }

    readonly property bool hasTrack: !!player && (player.isPlaying || player.length > 0)

    readonly property string title: player?.trackTitle ?? ""
    readonly property string artist: player?.trackArtist ?? ""
    readonly property string artUrl: player?.trackArtUrl ?? ""
    readonly property real pos: player?.position ?? 0
    readonly property real len: player?.length ?? 0
    readonly property bool playing: player?.isPlaying ?? false

    Timer {
        interval: 1250
        repeat: true
        running: root.player?.playbackState == MprisPlaybackState.Playing
        onTriggered: root.player?.positionChanged()
    }
}
