.pragma library

function wsOutput(workspaces, wsId) {
    const idx = workspaces.indexOfId(wsId);
    if (idx === -1)
        return "";
    return workspaces.get(idx).output;
}

function onScreen(ws, screenName) {
    return screenName === "" || ws.output === screenName;
}

function volumeIcon(vol, muted) {
    if (muted) {
        if (vol > 0.85)
            return "Volume-mute";
        return "Volume-mute-outline";
    }
    if (vol <= 0.01)
        return "Volume-off-outline";
    if (vol < 0.5)
        return "Volume-medium-outline";
    if (vol <= 0.85)
        return "Volume-high-outline";
    return "Volume-high";
}

// Shared charge-level tiers: green when nearly full and charging, red
// below 10%, amber below 25%.
function batteryColor(pct, charging, high, warning, low, normal) {
    if (pct < 0)
        return normal;
    if (charging && pct > 85)
        return high;
    if (pct < 10)
        return low;
    if (pct < 25)
        return warning;
    return normal;
}

function clamp01(v) {
    return Math.min(Math.max(v, 0), 1);
}

// Signal-strength quartile (1..4), 0 when the radio reports nothing.
function wifiLevel(strength) {
    if (strength <= 0)
        return 0;
    if (strength >= 75)
        return 4;
    if (strength >= 50)
        return 3;
    if (strength >= 25)
        return 2;
    return 1;
}

// Matches the MDI assets: WifiStrength-<level>[Lock], or the empty/off
// variants at level 0.
function wifiIcon(strength, secured, enabled) {
    if (!enabled)
        return "WifiStrengthOffOutline";
    const level = wifiLevel(strength);
    if (level === 0)
        return secured ? "WifiStrength-1Lock" : "WifiStrengthOutline";
    return "WifiStrength-" + level + (secured ? "Lock" : "");
}

// Human readable byte rate, e.g. 12 B/s, 45 KB/s, 1.2 MB/s.
function formatRate(bytesPerSec) {
    if (bytesPerSec < 1024)
        return Math.round(bytesPerSec) + "B";
    if (bytesPerSec < 1048576)
        return (bytesPerSec / 1024).toFixed(bytesPerSec < 10240 ? 1 : 0) + "K";
    if (bytesPerSec < 1073741824)
        return (bytesPerSec / 1048576).toFixed(1) + "M";
    return (bytesPerSec / 1073741824).toFixed(2) + "G";
}
