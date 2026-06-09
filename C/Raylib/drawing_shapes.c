#include <stdio.h>

#include "raylib.h"
#include <stdlib.h>
#include <time.h>

const Color colors[] = {
    MAGENTA, PINK, GRAY,
    SKYBLUE, DARKPURPLE,
    BLACK, RED, PURPLE,
    GREEN, BLUE, BROWN,
};

Color getRandomColor() {
    return colors[rand() % sizeof(colors)];
}

int main() {
    srand(time(NULL));
    const int screenWidth = 960;
    const int screenHeight = 540;

    Color randColor = getRandomColor();
    bool goLeft = true;
    int ballXPos = 50;

    InitWindow(screenWidth, screenHeight, "Drawing Shapes!");

    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(RAYWHITE);

        // for (int offset = 0; offset <= 100; offset++) {
            // Color color = RED;
            // if (offset % 2 == 0) { color = BLACK; }
            // if (offset == 100) { color = RAYWHITE; }
            // DrawRectangle(offset, offset, screenWidth - offset * 2, screenHeight - offset * 2, color);
        // }


        for (int i = 0; i < 6; i++) {
            if (i % 2 == 0) {
                DrawCircle(ballXPos, (i * 90) + 50, 25, randColor);
            } else {
                DrawCircle(screenWidth-ballXPos, (i * 90) + 50, 25, randColor);
            }
        }

        if (goLeft && ballXPos < screenWidth - 50) {
            ballXPos++;
            if (ballXPos == screenWidth - 50) {
                randColor = getRandomColor();
                goLeft = false;
            }
        } else if (!goLeft && ballXPos > 50 ) {
            ballXPos--;
            if (ballXPos == 50) {
                randColor = getRandomColor();
                goLeft = true;
            }
        }

        DrawText("randColor", screenWidth/2 - 55, screenHeight/2, 20, randColor);

        EndDrawing();
    }

    CloseWindow();
}