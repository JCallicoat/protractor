#include "raylib.h"
#include <math.h>
#include <stdio.h>

int main(void) {

  // Window setup: MSAA + resizable + topmost
  SetConfigFlags(FLAG_MSAA_4X_HINT | FLAG_WINDOW_RESIZABLE |
                 FLAG_WINDOW_TOPMOST);

  const int screenWidth = 650;
  const int screenHeight = 650;
  InitWindow(screenWidth, screenHeight, "Screen Protractor");

  SetTargetFPS(60);

  // Initial opacity
  float opacity = 0.7f;
  SetWindowOpacity(opacity);

  // Initialize line angle to 0 degrees (12 o'clock, upward)
  float lineAngle = -90.0f * DEG2RAD; // -90 degrees in radians for 12 o'clock
  bool updateLine = true;             // Flag to control line updating

  while (!WindowShouldClose()) {

    if (IsKeyPressed(KEY_Q))
      break; // Exit on Q key

    if (IsKeyPressed(KEY_MINUS) || IsKeyPressed(KEY_KP_SUBTRACT))
      opacity -= 0.1f;

    if (IsKeyPressed(KEY_EQUAL) || IsKeyPressed(KEY_KP_ADD))
      opacity += 0.1f;

    if (IsKeyPressed(KEY_ZERO) || IsKeyPressed(KEY_KP_0))
      opacity = 0.5f;

    if (IsKeyPressed(KEY_S) || IsMouseButtonPressed(MOUSE_LEFT_BUTTON))
      updateLine = !updateLine; // Toggle line updating

    if (opacity < 0.1f)
      opacity = 0.1f;
    if (opacity > 1.0f)
      opacity = 1.0f;
    SetWindowOpacity(opacity);

    // Protractor rendering
    int w = GetScreenWidth();
    int h = GetScreenHeight();
    Vector2 center = {w / 2.0f, h / 2.0f};
    int radius = (w < h ? w : h) / 2 - 10;

    if (radius < 0)
      radius = 0; // Safety

    BeginDrawing();
    ClearBackground(RAYWHITE);

    if (radius > 0) {
      // Draw smooth circle outline as a ring (3 px thick)
      DrawRing(center, radius - 1, radius + 2, 0, 360, 720, BLACK);

      // Draw central dot
      DrawCircleV(center, 4, BLACK);

      // Label position
      float textRadius = radius * 0.83f;

      // Scale text with size
      int fontSize = radius / 15;

      // Diameter lines (0-180 and 90-270)
      float labelClearRadius = textRadius - fontSize; // Stop before labels
      float lineThickness = 2.0f; // Match visual weight of ticks
      DrawLineEx((Vector2){center.x, center.y - labelClearRadius},
                 (Vector2){center.x, center.y + labelClearRadius},
                 lineThickness, BLACK); // 0-180
      DrawLineEx((Vector2){center.x - labelClearRadius, center.y},
                 (Vector2){center.x + labelClearRadius, center.y},
                 lineThickness, BLACK); // 90-270

      // Draw degree ticks and labels
      for (int angle = 0; angle < 360; angle++) {
        float rad = (angle - 90) * DEG2RAD;
        float xOuter = center.x + cosf(rad) * radius;
        float yOuter = center.y + sinf(rad) * radius;
        float xInner, yInner;

        // Draw longer ticks every 10 degrees
        if (angle % 10 == 0) {
          xInner = center.x + cosf(rad) * (radius - radius * 0.10f);
          yInner = center.y + sinf(rad) * (radius - radius * 0.10f);
          DrawLineEx((Vector2){xInner, yInner}, (Vector2){xOuter, yOuter},
                     lineThickness, BLACK);

          // Draw labels every 30 degrees
          if (angle % 30 == 0) {
            char label[8];
            sprintf(label, "%d", angle);
            float xText = center.x + cosf(rad) * textRadius;
            float yText = center.y + sinf(rad) * textRadius;
            if (fontSize < 10)
              fontSize = 10;
            int textW = MeasureText(label, fontSize);
            DrawText(label, xText - textW / 2.0, yText - fontSize / 2.0,
                     fontSize, BLACK);
          }

          // Draw medium ticks every 5 degrees
        } else if (angle % 5 == 0) {
          xInner = center.x + cosf(rad) * (radius - radius * 0.07f);
          yInner = center.y + sinf(rad) * (radius - radius * 0.07f);
          DrawLineEx((Vector2){xInner, yInner}, (Vector2){xOuter, yOuter},
                     lineThickness, BLACK);

          // Draw short ticks otherwise
        } else {
          xInner = center.x + cosf(rad) * (radius - radius * 0.05f);
          yInner = center.y + sinf(rad) * (radius - radius * 0.05f);
          DrawLineEx((Vector2){xInner, yInner}, (Vector2){xOuter, yOuter},
                     lineThickness, BLACK);
        }
      }

      // Update red line angle if enabled
      if (updateLine) {
        Vector2 mouse = GetMousePosition();
        if (mouse.x > 0 || mouse.y > 0) {
          float dx = mouse.x - center.x;
          float dy = mouse.y - center.y;
          lineAngle = atan2f(dy, dx);
        }
      }

      // Draw 1px red line from center to window edge
      float maxDist = fmaxf(w, h) * 1.414f; // Diagonal for window edge
      Vector2 end = {center.x + cosf(lineAngle) * maxDist,
                     center.y + sinf(lineAngle) * maxDist};
      DrawLineEx(center, end, 1.0f, RED);

      // Draw red label 10px above and 10px to the right of center
      int degree = (int)((lineAngle * RAD2DEG + 90.0f) + 360.0f) % 360;
      char degreeLabel[11];
      sprintf(degreeLabel, "%d degrees", degree);
      if (fontSize < 10)
        fontSize = 10;
      DrawText(degreeLabel, center.x + 10, center.y - 10 - fontSize, fontSize,
               RED);

      // Draw control labels in top-left corner
      int labelFontSize = 16; // Small font for labels
      DrawText("+/-: adjust opacity", 10, 10, labelFontSize, BLACK);
      DrawText("0: reset opacity", 10, 10 + labelFontSize + 2, labelFontSize,
               BLACK);
      DrawText("s: save angle", 10, 10 + 2 * (labelFontSize + 2), labelFontSize,
               BLACK);
      DrawText("q: quit", 10, 10 + 3 * (labelFontSize + 2), labelFontSize,
               BLACK);
    }

    EndDrawing();
  }

  CloseWindow();
  return 0;
}
