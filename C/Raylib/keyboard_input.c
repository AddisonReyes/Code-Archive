#include "raylib.h"

int main() {
    const int screenWidth = 640;
    const int screenHeight = 480;

    InitWindow(screenWidth, screenHeight, "Raylib hello world");

    Vector2 playerPos = { screenWidth/2, screenHeight/2 };
    Color playerColor = PURPLE;
    float playerSpeed = 6.7f;
    
    char* releasedText = "";
    char* keyDownText = "";
    char* pressedText = "";

    SetTargetFPS(60);

    while (!WindowShouldClose()) {
        if (IsKeyDown(KEY_W)) {
            keyDownText = "\'W\' key down";
            playerPos.y -= playerSpeed;
        }
        if (IsKeyDown(KEY_A)) {
            keyDownText = "\'A\' key down";
            playerPos.x -= playerSpeed;
        }
        if (IsKeyDown(KEY_S)) {
            keyDownText = "\'S\' key down";
            playerPos.y += playerSpeed;
        }
        if (IsKeyDown(KEY_D)) {
            keyDownText = "\'D\' key down";
            playerPos.x += playerSpeed;
        }


        if (IsKeyPressed(KEY_W)) pressedText = "\'W\' pressed";
        if (IsKeyPressed(KEY_A)) pressedText = "\'A\' pressed";
        if (IsKeyPressed(KEY_S)) pressedText = "\'S\' pressed";
        if (IsKeyPressed(KEY_D)) pressedText = "\'D\' pressed";

        if (IsKeyReleased(KEY_W)) releasedText = "\'W\' released";
        if (IsKeyReleased(KEY_A)) releasedText = "\'A\' released";
        if (IsKeyReleased(KEY_S)) releasedText = "\'S\' released";
        if (IsKeyReleased(KEY_D)) releasedText = "\'D\' released";
        
        BeginDrawing();
        ClearBackground(RAYWHITE);
        
        
        DrawText(keyDownText, screenWidth/2 - 55, screenHeight/2 - 32, 20, BLACK);
        DrawText(pressedText, screenWidth/2 - 55, screenHeight/2, 20, BLACK);
        DrawText(releasedText, screenWidth/2 - 55, screenHeight/2 + 32, 20, BLACK);

        DrawCircle(playerPos.x, playerPos.y, 16.0f, playerColor);

        EndDrawing();
    }

    CloseWindow();
}