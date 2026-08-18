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
    if (muted)
        return "Volume-mute-outline";
    if (vol <= 0.01)
        return "Volume-off-outline";
    if (vol < 0.5)
        return "Volume-medium-outline";
    if (vol <= 0.85)
        return "Volume-high-outline";
    return "Volume-high";
}
