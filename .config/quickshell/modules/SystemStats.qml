pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Samples CPU, memory, and network utilisation once per second into rolling
// history buffers for the status panel graphs.
Singleton {
    id: root

    readonly property int historyLength: 120
    readonly property int sampleInterval: 1000

    // Current usage fractions (0..1)
    property real cpuUsage: 0
    property real ramUsage: 0

    // Network throughput in bytes/s
    property real netDownRate: 0
    property real netUpRate: 0

    // Rolling histories, oldest first, entries 0..1. The network graph is
    // normalised against a decaying peak so slow links still show shape.
    property var cpuHistory: []
    property var ramHistory: []
    property var netHistory: []

    property real _prevCpuTotal: 0
    property real _prevCpuIdle: 0
    property bool _cpuPrimed: false
    property real _prevRx: -1
    property real _prevTx: -1
    property var _netRates: []

    readonly property real _netFloor: 32 * 1024

    FileView {
        id: statView
        path: "/proc/stat"
    }

    FileView {
        id: meminfoView
        path: "/proc/meminfo"
    }

    FileView {
        id: netdevView
        path: "/proc/net/dev"
    }

    Timer {
        interval: root.sampleInterval
        running: true
        repeat: true
        onTriggered: root.sample()
    }

    function sample() {
        _sampleCpu();
        _sampleRam();
        _sampleNet();
    }

    function _push(arr, value) {
        const next = arr.slice(-(root.historyLength - 1));
        next.push(value);
        return next;
    }

    function _clamp01(v) {
        return Math.min(Math.max(v, 0), 1);
    }

    function _sampleCpu() {
        statView.reload();
        const text = statView.text();
        if (!text)
            return;
        const line = text.split("\n").find(l => l.startsWith("cpu "));
        if (!line)
            return;
        const p = line.trim().split(/\s+/);
        let total = 0;
        for (let i = 1; i < p.length; i++)
            total += parseInt(p[i]);
        const idle = parseInt(p[4]) + parseInt(p[5]);
        if (_cpuPrimed && total > _prevCpuTotal) {
            cpuUsage = _clamp01((total - _prevCpuTotal - (idle - _prevCpuIdle)) / (total - _prevCpuTotal));
            cpuHistory = _push(cpuHistory, cpuUsage);
        }
        _prevCpuTotal = total;
        _prevCpuIdle = idle;
        _cpuPrimed = true;
    }

    function _sampleRam() {
        meminfoView.reload();
        const text = meminfoView.text();
        if (!text)
            return;
        let total = 0;
        let avail = 0;
        for (let line of text.split("\n")) {
            if (line.startsWith("MemTotal:"))
                total = parseFloat(line.split(/\s+/)[1]);
            else if (line.startsWith("MemAvailable:"))
                avail = parseFloat(line.split(/\s+/)[1]);
        }
        if (total <= 0)
            return;
        ramUsage = _clamp01((total - avail) / total);
        ramHistory = _push(ramHistory, ramUsage);
    }

    function _sampleNet() {
        netdevView.reload();
        const text = netdevView.text();
        if (!text)
            return;
        let rx = 0;
        let tx = 0;
        for (let line of text.split("\n").slice(2)) {
            const idx = line.indexOf(":");
            if (idx === -1)
                continue;
            const name = line.slice(0, idx).trim();
            if (name === "lo")
                continue;
            const f = line.slice(idx + 1).trim().split(/\s+/);
            rx += parseInt(f[0]);
            tx += parseInt(f[8]);
        }
        if (_prevRx >= 0 && _prevTx >= 0) {
            netDownRate = Math.max(0, rx - _prevRx);
            netUpRate = Math.max(0, tx - _prevTx);
            const combined = netDownRate + netUpRate;
            _netRates = _push(_netRates, combined);
            let peak = _netFloor;
            for (let r of _netRates)
                if (r > peak)
                    peak = r;
            netHistory = _push(netHistory, _clamp01(combined / peak));
        }
        _prevRx = rx;
        _prevTx = tx;
    }
}
