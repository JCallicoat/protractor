const std = @import("std");
const ray = @import("raylib.zig");

const protractor_png_data = @embedFile("resources/protractor.png");

pub fn main() !void {
    var opacity: f16 = 0.5;
    const screenWidth = 670;
    const screenHeight = 646;

    // SetConfigFlags(FLAG_WINDOW_UNDECORATED);

    ray.InitWindow(screenWidth, screenHeight, "Screen Protractor");

    // make window always on top
    ray.SetWindowState(ray.FLAG_WINDOW_TOPMOST);

    // make window non resizeable
    ray.ClearWindowState(ray.FLAG_WINDOW_RESIZABLE);

    // make window 50% transparent
    ray.SetWindowOpacity(opacity);

    // create our protractor texture
    const image = ray.LoadImageFromMemory(".png", protractor_png_data, protractor_png_data.len);
    const texture = ray.LoadTextureFromImage(image);
    ray.UnloadImage(image);

    ray.SetTargetFPS(60);

    // for mouse dragging the window
    // var mouseDelta = { 0 };
    // var windowPosition = { 0 };

    var exitWindow = false;
    while (!exitWindow) {
        if (ray.WindowShouldClose() or ray.IsKeyPressed(ray.KEY_Q))
            exitWindow = true;

        // handle keypresses
        if (ray.IsKeyPressed(ray.KEY_MINUS))
            opacity -= 0.1;

        if (ray.IsKeyPressed(ray.KEY_EQUAL))
            opacity += 0.1;

        if (ray.IsKeyPressed(ray.KEY_ZERO))
            opacity = 0.5;

        if (ray.IsKeyPressed(ray.KEY_D)) {
            if (ray.IsWindowState(ray.FLAG_WINDOW_UNDECORATED)) {
                ray.ClearWindowState(ray.FLAG_WINDOW_UNDECORATED);
            } else {
                ray.SetWindowState(ray.FLAG_WINDOW_UNDECORATED);
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
        ray.SetWindowOpacity(opacity);

        // draw our protractor
        ray.BeginDrawing();
        ray.ClearBackground(ray.BLANK);
        ray.DrawTexture(texture, 0, 0, ray.RAYWHITE);
        ray.EndDrawing();
    }

    ray.CloseWindow();
}
