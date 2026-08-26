import QtQuick

// Minimal line graph for a rolling array of 0..1 values, newest at the
// right edge. Fill fades out below the line.
Canvas {
    id: root

    property var values: []
    property color lineColor: "#ffffff"
    property real fillAlpha: 0.22
    property real lineWidth: 1.5

    onValuesChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()
    onLineColorChanged: requestPaint()

    onPaint: {
        const ctx = getContext("2d");
        ctx.clearRect(0, 0, width, height);
        const pts = root.values;
        if (!pts || pts.length < 2)
            return;

        const margin = 2;
        const span = height - 2 * margin;
        const c = root.lineColor;
        const rgba = a => `rgba(${Math.round(c.r * 255)},${Math.round(c.g * 255)},${Math.round(c.b * 255)},${a})`;

        ctx.beginPath();
        ctx.moveTo(0, height);
        for (let i = 0; i < pts.length; i++) {
            const px = (i / (pts.length - 1)) * width;
            const py = margin + (1 - pts[i]) * span;
            ctx.lineTo(px, py);
        }
        ctx.lineTo(width, height);
        ctx.closePath();
        const grad = ctx.createLinearGradient(0, height, 0, 0);
        grad.addColorStop(0, rgba(root.fillAlpha * 0.3));
        grad.addColorStop(1, rgba(root.fillAlpha));
        ctx.fillStyle = grad;
        ctx.fill();

        ctx.beginPath();
        for (let i = 0; i < pts.length; i++) {
            const px = (i / (pts.length - 1)) * width;
            const py = margin + (1 - pts[i]) * span;
            if (i === 0)
                ctx.moveTo(px, py);
            else
                ctx.lineTo(px, py);
        }
        ctx.strokeStyle = rgba(1);
        ctx.lineWidth = root.lineWidth;
        ctx.lineJoin = "round";
        ctx.stroke();
    }
}
