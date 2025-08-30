const std = @import("std");
const rl = @import("raylib");

pub fn main() !void {
    // Window setup: MSAA + resizable + topmost
    rl.setConfigFlags(rl.ConfigFlags{ .msaa_4x_hint = true, .window_resizable = true, .window_topmost = true });

    const screenWidth = 650;
    const screenHeight = 650;
    rl.initWindow(screenWidth, screenHeight, "Screen Protractor");

    rl.setTargetFPS(60);

    // Initial opacity
    var opacity: f32 = 0.7;
    rl.setWindowOpacity(opacity);

    // Initialize line angle to 0 degrees (12 o'clock, upward)
    var lineAngle: f32 = -90.0 * std.math.rad_per_deg; // -90 degrees in radians for 12 o'clock
    var updateLine = true; // Flag to control line updating

    while (!rl.windowShouldClose()) {
        if (rl.isKeyPressed(.q))
            break; // Exit on Q key

        if (rl.isKeyPressed(.minus) or rl.isKeyPressed(.kp_subtract))
            opacity -= 0.1;

        if (rl.isKeyPressed(.equal) or rl.isKeyPressed(.kp_add))
            opacity += 0.1;

        if (rl.isKeyPressed(.zero) or rl.isKeyPressed(.kp_0))
            opacity = 0.5;

        if (rl.isKeyPressed(.s) or rl.isMouseButtonPressed(.left))
            updateLine = !updateLine; // Toggle line updating

        if (opacity < 0.1)
            opacity = 0.1;
        if (opacity > 1.0)
            opacity = 1.0;
        rl.setWindowOpacity(opacity);

        // Protractor rendering
        const w = @as(f32, @floatFromInt(rl.getScreenWidth()));
        const h = @as(f32, @floatFromInt(rl.getScreenHeight()));
        const center = rl.Vector2.init(w / 2.0, h / 2.0);
        var radius: f32 = (if (w < h) w else h) / 2.0 - 10.0;

        if (radius < 0.0)
            radius = 0.0; // Safety

        rl.beginDrawing();
        rl.clearBackground(.white);

        if (radius > 0) {
            // Draw smooth circle outline as a ring (3 px thick)
            rl.drawRing(center, radius - 1, radius + 2, 0, 360, 720, .black);

            // Draw central dot
            rl.drawCircleV(center, 4.0, .black);

            // Label position
            const textRadius: f32 = radius * 0.83;

            // Scale text with size
            var fontSize = radius / 15;

            // Diameter lines (0-180 and 90-270)
            const labelClearRadius: f32 = textRadius - fontSize; // Stop before labels
            const lineThickness: f32 = 2.0; // Match visual weight of ticks
            rl.drawLineEx(rl.Vector2.init(center.x, center.y - labelClearRadius), rl.Vector2.init(center.x, center.y + labelClearRadius), lineThickness, .black); // 0-180
            rl.drawLineEx(rl.Vector2.init(center.x - labelClearRadius, center.y), rl.Vector2.init(center.x + labelClearRadius, center.y), lineThickness, .black); // 90-270

            // Draw degree ticks and labels
            var angle: i32 = 0;
            while (angle < 360) : (angle += 1) {
                const rad: f32 = @as(f32, @floatFromInt(angle - 90)) * std.math.rad_per_deg;
                const xOuter: f32 = center.x + @cos(rad) * radius;
                const yOuter: f32 = center.y + @sin(rad) * radius;
                var xInner: f32 = 0.0;
                var yInner: f32 = 0.0;

                // Draw longer ticks every 10 degrees
                if (@rem(angle, 10) == 0) {
                    xInner = center.x + @cos(rad) * (radius - radius * 0.10);
                    yInner = center.y + @sin(rad) * (radius - radius * 0.10);
                    rl.drawLineEx(rl.Vector2.init(xInner, yInner), rl.Vector2.init(xOuter, yOuter), lineThickness, .black);

                    // Draw labels every 30 degrees
                    if (@rem(angle, 30) == 0) {
                        const label = rl.textFormat("%d", .{angle});
                        const xText: i32 = @intFromFloat(center.x + @cos(rad) * textRadius);
                        const yText: i32 = @intFromFloat(center.y + @sin(rad) * textRadius);
                        if (fontSize < 10)
                            fontSize = 10;
                        const textW = rl.measureText(label, @intFromFloat(fontSize));
                        rl.drawText(label, xText - @divExact(textW, 2), yText - @as(i32, @intFromFloat(fontSize / 2)), @as(i32, @intFromFloat(fontSize)), .black);
                    }

                    // Draw medium ticks every 5 degrees
                } else if (@rem(angle, 5) == 0) {
                    xInner = center.x + @cos(rad) * (radius - radius * 0.07);
                    yInner = center.y + @sin(rad) * (radius - radius * 0.07);
                    rl.drawLineEx(rl.Vector2.init(xInner, yInner), rl.Vector2.init(xOuter, yOuter), lineThickness, .black);

                    // Draw short ticks otherwise
                } else {
                    xInner = center.x + @cos(rad) * (radius - radius * 0.05);
                    yInner = center.y + @sin(rad) * (radius - radius * 0.05);
                    rl.drawLineEx(rl.Vector2.init(xInner, yInner), rl.Vector2.init(xOuter, yOuter), lineThickness, .black);
                }
            }

            // Update red line angle if enabled
            if (updateLine) {
                const mouse = rl.getMousePosition();
                if (mouse.x > 0 or mouse.y > 0) {
                    const dx = mouse.x - center.x;
                    const dy = mouse.y - center.y;
                    lineAngle = std.math.atan2(dy, dx);
                }
            }

            // Draw 1px red line from center to window edge
            const maxDist = @max(w, h) * 1.414; // Diagonal for window edge
            const end = rl.Vector2.init(center.x + @cos(lineAngle) * maxDist, center.y + @sin(lineAngle) * maxDist);
            rl.drawLineEx(center, end, 1.0, .red);

            // Draw red label 10px above and 10px to the right of center
            const degree: i32 = @rem(@as(i32, @intFromFloat((lineAngle * std.math.deg_per_rad + 90) + 360)), 360);
            const degreeLabel = rl.textFormat("%d degrees", .{degree});

            if (fontSize < 10)
                fontSize = 10;
            rl.drawText(degreeLabel, @as(i32, @intFromFloat(center.x + 10)), @as(i32, @intFromFloat(center.y - 10 - fontSize)), @as(i32, @intFromFloat(fontSize)), .red);

            // Draw control labels in top-left corner
            const labelFontSize = 16; // Small font for labels
            rl.drawText("+/-: adjust opacity", 10, 10, labelFontSize, .black);
            rl.drawText("0: reset opacity", 10, 10 + labelFontSize + 2, labelFontSize, .black);
            rl.drawText("s: save angle", 10, 10 + 2 * (labelFontSize + 2), labelFontSize, .black);
            rl.drawText("q: quit", 10, 10 + 3 * (labelFontSize + 2), labelFontSize, .black);
        }

        rl.endDrawing();
    }

    rl.closeWindow();
}
