import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Services.Pipewire
import "../themes"

Scope {
	id: root

	// Bind the pipewire node so its volume will be tracked
	PwObjectTracker {
		objects: [ Pipewire.defaultAudioSink ]
	}

	property bool primed: false

	Connections {
		target: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio : null

		function onVolumeChanged() {
			if (!root.primed) { root.primed = true; return }
			root.shouldShowOsd = true;
			hideTimer.restart();
		}

		function onMutedChanged() {
			if (!root.primed) { root.primed = true; return }
			root.shouldShowOsd = true;
			hideTimer.restart();
		}
	}

	readonly property real vol: Pipewire.defaultAudioSink?.audio?.volume ?? 0
	readonly property bool muted: Pipewire.defaultAudioSink?.audio?.muted ?? false

	readonly property string iconName: {
		if (muted) return "Volume-mute-outline"
		if (vol <= 0.01) return "Volume-off-outline"
		if (vol < 0.5) return "Volume-medium-outline"
		return "Volume-high-outline"
	}

	property bool shouldShowOsd: false

	Timer {
		id: hideTimer
		interval: 1000
		onTriggered: root.shouldShowOsd = false
	}

	// The OSD window will be created and destroyed based on shouldShowOsd.
	// PanelWindow.visible could be set instead of using a loader, but using
	// a loader will reduce the memory overhead when the window isn't open.
	LazyLoader {
		active: root.shouldShowOsd

		PanelWindow {
			// Since the panel's screen is unset, it will be picked by the compositor
			// when the window is created. Most compositors pick the current active monitor.

			anchors.bottom: true
			margins.bottom: screen.height / 12
			exclusiveZone: 0

			implicitWidth: 320
			implicitHeight: 44
			color: "transparent"

			// An empty click mask prevents the window from blocking mouse events.
			mask: Region {}

			Rectangle {
				anchors.fill: parent
				radius: height / 2
				color: Theme.palette.barBg
				border.color: Theme.palette.barBorder
				border.width: 2

				RowLayout {
					anchors {
						fill: parent
						leftMargin: 12
						rightMargin: 16
					}

					MultiEffect {
						Layout.preferredWidth: 24
						Layout.preferredHeight: 24
						source: Image {
							width: 24
							height: 24
							source: Qt.resolvedUrl("../assets/" + root.iconName + ".svg")
							sourceSize.width: 24
							sourceSize.height: 24
						}
						colorization: 1
						colorizationColor: Theme.palette.text
					}

					Rectangle {
						// Stretches to fill all left-over space
						Layout.fillWidth: true

						implicitHeight: 8
						radius: height / 2
						color: Qt.rgba(Theme.palette.barBorder.r, Theme.palette.barBorder.g, Theme.palette.barBorder.b, 0.5)

						Rectangle {
							anchors {
								left: parent.left
								top: parent.top
								bottom: parent.bottom
							}

							width: parent.width * root.vol
							radius: parent.radius
							color: Theme.palette.accent
						}
					}
				}
			}
		}
	}
}
