#include "protractor.h"
#include <raylib.h>

float opacity = 0.5;
int screenWidth = 650;
int screenHeight = 650;

int main(void) {
  /* SetConfigFlags(FLAG_WINDOW_UNDECORATED); */

  InitWindow(screenWidth, screenHeight, "Screen Protractor");

  // make window always on top
  SetWindowState(FLAG_WINDOW_TOPMOST);

  // make window non resizeable
  ClearWindowState(FLAG_WINDOW_RESIZABLE);

  // make window 50% transparent
  SetWindowOpacity(opacity);

  // create out protractor texture
  /* Image image = LoadImage("protractor.png"); */
  Image image = LoadImageFromMemory(".png", protractor_png, protractor_png_len);
  Texture2D texture = LoadTextureFromImage(image);
  UnloadImage(image);

  SetTargetFPS(60);

  // for mouse dragging the window
  // Vector2 mouseDelta = { 0 };
  // Vector2 windowPosition = { 0 };

  bool exitWindow = false;
  while (!exitWindow) {
    if (WindowShouldClose() || IsKeyPressed(KEY_Q))
      exitWindow = true;

    // handle keypresses
    if (IsKeyPressed(KEY_MINUS))
      opacity -= 0.1;

    if (IsKeyPressed(KEY_EQUAL))
      opacity += 0.1;

    if (IsKeyPressed(KEY_ZERO))
      opacity = 0.5;

    if (IsKeyPressed(KEY_D)) {
      if (IsWindowState(FLAG_WINDOW_UNDECORATED))
        ClearWindowState(FLAG_WINDOW_UNDECORATED);
      else
        SetWindowState(FLAG_WINDOW_UNDECORATED);
    }

    // handle mouse drag
    // windowPosition = GetWindowPosition();
    // mouseDelta = GetMouseDelta();
    // if(IsMouseButtonDown(MOUSE_LEFT_BUTTON)) {
    //    SetWindowPosition(mouseDelta.x + windowPosition.x, mouseDelta.y +
    //    windowPosition.y);
    //}

    // update window opacity
    if (opacity < 0.01)
      opacity = 0.1;
    else if (opacity > 1.0)
      opacity = 1.0;
    SetWindowOpacity(opacity);

    // draw our protrator
    ClearBackground(BLANK);
    BeginDrawing();
    DrawTexture(texture, 0, 0, RAYWHITE);
    EndDrawing();
  }

  CloseWindow();
}
