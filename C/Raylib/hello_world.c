#include "raylib.h"

int main() {
    const int screenWidth = 640;
    const int screenHeight = 480;

    InitWindow(screenWidth, screenHeight, "Raylib hello world");

    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(RAYWHITE);
        DrawText("Hello world!", screenWidth/2 - 55, screenHeight/2, 20, BLACK);
        EndDrawing();
    }

    CloseWindow();
}