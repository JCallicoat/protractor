package main

import (
	_ "embed"

	rl "github.com/gen2brain/raylib-go/raylib"
)

//go:embed resources/protractor.png
var protractor_png_data []byte

func main() {
	var opacity float32 = 0.5
	const screenWidth = 650
	const screenHeight = 650

	// rl.SetConfigFlags(rl.FLAG_WINDOW_UNDECORATED);

	rl.InitWindow(screenWidth, screenHeight, "Screen Protractor")

	// make window always on top
	rl.SetWindowState(rl.FlagWindowTopmost)

	// make window non resizeable
	rl.ClearWindowState(rl.FlagWindowResizable)

	// make window 50% transparent
	rl.SetWindowOpacity(opacity)

	// create our protractor texture
	var image = rl.LoadImageFromMemory(".png", protractor_png_data, int32(len(protractor_png_data)))
	var texture = rl.LoadTextureFromImage(image)
	rl.UnloadImage(image)

	rl.SetTargetFPS(60)

	// for mouse dragging the window
	// var mouseDelta = { 0 };
	// var windowPosition = { 0 };

	var exitWindow = false
	for !exitWindow {
		if rl.WindowShouldClose() || rl.IsKeyPressed(rl.KeyQ) {
			exitWindow = true
		}

		// handle keypresses
		if rl.IsKeyPressed(rl.KeyMinus) {
			opacity -= 0.1
		}

		if rl.IsKeyPressed(rl.KeyEqual) {
			opacity += 0.1
		}

		if rl.IsKeyPressed(rl.KeyZero) {
			opacity = 0.5
		}

		if rl.IsKeyPressed(rl.KeyD) {
			if rl.IsWindowState(rl.FlagWindowUndecorated) {
				rl.ClearWindowState(rl.FlagWindowUndecorated)
			} else {
				rl.SetWindowState(rl.FlagWindowUndecorated)
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
		if opacity < 0.01 {
			opacity = 0.1
		} else if opacity > 1.0 {
			opacity = 1.0
		}
		rl.SetWindowOpacity(opacity)

		// draw our protractor
		rl.BeginDrawing()
		rl.ClearBackground(rl.Blank)
		rl.DrawTexture(texture, 0, 0, rl.White)
		rl.EndDrawing()
	}

	rl.CloseWindow()
}
