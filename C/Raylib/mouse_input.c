#include "raylib.h"
#include "rlgl.h"
#include "raymath.h"

int main() {
    const int screenWidth = 640;
    const int screenHeight = 480;

    InitWindow(screenWidth, screenHeight, "Raylib hello world");

    Camera2D camera = { 0 };
    camera.zoom = 1.0f;
    
    Vector2 playerPos = (Vector2){ screenWidth/2, screenHeight/2 };
    Color playerColor = BLUE;
    float playerSpeed = 6.7f;

    SetTargetFPS(60);

    while (!WindowShouldClose()) {
        if (IsMouseButtonDown(MOUSE_BUTTON_RIGHT))
        {
            playerPos = (Vector2){GetMouseX(), GetMouseY()};
        }

        float wheel = GetMouseWheelMove();
        if (wheel != 0)
        {
            Vector2 mouseWorldPos = GetScreenToWorld2D(GetMousePosition(), camera);
            
            camera.offset = GetMousePosition();
            camera.target = mouseWorldPos;
            
            float scale = 0.2f*wheel;
            camera.zoom = Clamp(expf(logf(camera.zoom)+scale), 0.125f, 64.0f);
        }

        BeginDrawing();
        ClearBackground(RAYWHITE);
        BeginMode2D(camera);
        
        DrawTextEx(GetFontDefault(), TextFormat("[%i, %i]", (int)playerPos.x, (int)playerPos.y),
            Vector2Add(playerPos, (Vector2){ -44, -24 }), 20, 2, BLACK);
        DrawCircle(playerPos.x, playerPos.y, 6.0f, playerColor);

        EndMode2D();
        DrawCircleV(GetMousePosition(), 4, DARKGRAY);
        DrawTextEx(GetFontDefault(), TextFormat("[%i, %i]", GetMouseX(), GetMouseY()),
            Vector2Add(GetMousePosition(), (Vector2){ -44, -24 }), 20, 2, BLACK);

        EndDrawing();
    }

    CloseWindow();
}