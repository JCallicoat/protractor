const std = @import("std");
const rl = @import("raylib.zig");

const protractor_png_data = @embedFile("resources/protractor.png");

pub fn main() !void {
    var opacity: f16 = 0.5;
    const screenWidth = 670;
    const screenHeight = 646;

    // rl.SetConfigFlags(rl.FLAG_WINDOW_UNDECORATED);

    rl.InitWindow(screenWidth, screenHeight, "Screen Protractor");

    // make window always on top
    rl.SetWindowState(rl.FLAG_WINDOW_TOPMOST);

    // make window non resizeable
    rl.ClearWindowState(rl.FLAG_WINDOW_RESIZABLE);

    // make window 50% transparent
    rl.SetWindowOpacity(opacity);

    // create our protractor texture
    const image = rl.LoadImageFromMemory(".png", protractor_png_data, protractor_png_data.len);
    const texture = rl.LoadTextureFromImage(image);
    rl.UnloadImage(image);

    rl.SetTargetFPS(60);

    // for mouse dragging the window
    // var mouseDelta = { 0 };
    // var windowPosition = { 0 };

    var exitWindow = false;
    while (!exitWindow) {
        if (rl.WindowShouldClose() or rl.IsKeyPressed(rl.KEY_Q))
            exitWindow = true;

        // handle keypresses
        if (rl.IsKeyPressed(rl.KEY_MINUS))
            opacity -= 0.1;

        if (rl.IsKeyPressed(rl.KEY_EQUAL))
            opacity += 0.1;

        if (rl.IsKeyPressed(rl.KEY_ZERO))
            opacity = 0.5;

        if (rl.IsKeyPressed(rl.KEY_D)) {
            if (rl.IsWindowState(rl.FLAG_WINDOW_UNDECORATED)) {
                rl.ClearWindowState(rl.FLAG_WINDOW_UNDECORATED);
            } else {
                rl.SetWindowState(rl.FLAG_WINDOW_UNDECORATED);
            }
        }

        // handle mouse drag
        // windowPosition = ray.GetWindowPosition();
        // mouseDelta = ray.GetMouseDelta();
        // if(ray.IsMouseButtonDown(ray.MOUSE_LEFT_BUTTON)) {
        //    ray.SetWindowPosition(mouseDelta.x + windowPosition.x, mouseDelta.y +
        //    windowPosition.y);
        //}

        // update window opacity
        if (opacity < 0.01) {
            opacity = 0.1;
        } else if (opacity > 1.0) {
            opacity = 1.0;
        }
        rl.SetWindowOpacity(opacity);

        // draw our protractor
        rl.BeginDrawing();
        rl.ClearBackground(rl.BLANK);
        rl.DrawTexture(texture, 0, 0, rl.RAYWHITE);
        rl.EndDrawing();
    }

    rl.CloseWindow();
}
