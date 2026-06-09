# 🎮 Game Development with raylib — Learning Path

A structured, hands-on checklist for going from zero to building real games with [raylib](https://www.raylib.com/).

```bash
gcc <file>.c -o <file> -lraylib -lGL -lm -lpthread -ldl -lrt -lX11
```

---

## 📦 Stage 1: Setup & Foundations

- [x] Install a C/C++ compiler (GCC, Clang, or MSVC)
- [x] Download and install raylib from [raylib.com](https://www.raylib.com/) or via a package manager
- [x] Set up your IDE or editor (VS Code, CLion, or Neovim)
- [x] Configure a build system (Makefile, CMake, or use the raylib template project)
- [x] Compile and run the `core_basic_window` example from raylib
- [x] Read the [raylib cheatsheet](https://www.raylib.com/cheatsheet/cheatsheet.html)
- [x] Understand the basic game loop structure (`InitWindow`, `WindowShouldClose`, `BeginDrawing`, `EndDrawing`, `CloseWindow`)

---

## 🖼️ Stage 2: 2D Graphics Basics

- [x] Draw basic shapes: rectangles, circles, lines, triangles
- [x] Understand screen coordinates and the 2D coordinate system
- [x] Load and display a texture/image with `LoadTexture` and `DrawTexture`
- [x] Draw text on screen with `DrawText` and `DrawTextEx`
- [x] Work with colors (`Color` struct, built-in color constants)
- [x] Implement a simple bouncing ball simulation
- [x] Understand `ClearBackground` and the rendering pipeline

---

## ⌨️ Stage 3: Input Handling

- [x] Detect keyboard input with `IsKeyDown`, `IsKeyPressed`, `IsKeyReleased`
- [x] Handle mouse input: position, buttons, and scroll wheel
- [x] Move a sprite/shape using keyboard input
- [x] Build a small demo: control a character with WASD or arrow keys

---

## ⏱️ Stage 4: Game Loop & Timing

- [ ] Understand delta time and frame-rate-independent movement
- [ ] Use `GetFrameTime()` to calculate `deltaTime`
- [ ] Target a fixed frame rate with `SetTargetFPS`
- [ ] Implement a simple timer and countdown system
- [ ] Build a stopwatch or reaction-time mini-game

---

## 🔊 Stage 5: Audio

- [ ] Initialize the audio device with `InitAudioDevice`
- [ ] Load and play a sound effect with `LoadSound` / `PlaySound`
- [ ] Load and stream background music with `LoadMusicStream` / `UpdateMusicStream`
- [ ] Control volume and pitch
- [ ] Add sound effects to your bouncing ball or character demo

---

## 🧩 Stage 6: Sprites & Animation

- [ ] Load a sprite sheet (texture atlas)
- [ ] Draw a sub-region of a texture with `DrawTextureRec`
- [ ] Implement frame-based 2D sprite animation
- [ ] Build an animated character that plays different animations (idle, walk, jump)
- [ ] Understand `Rectangle` and `Vector2` structs for positioning

---

## 🗺️ Stage 7: Collision Detection

- [ ] Implement AABB (Axis-Aligned Bounding Box) collision with `CheckCollisionRecs`
- [ ] Implement circle collision with `CheckCollisionCircles`
- [ ] Build a simple platformer collision system (floor, walls, ceiling)
- [ ] Detect and respond to player-enemy collisions
- [ ] Understand the difference between detection and resolution

---

## 🎮 Stage 8: Build Your First Complete Game

- [ ] Plan a simple game concept (Pong, Breakout, Snake, or Space Invaders)
- [ ] Define game states (Menu, Playing, Game Over)
- [ ] Implement a state machine to manage scenes/screens
- [ ] Add a scoring system and HUD (heads-up display)
- [ ] Add a start screen and game over screen
- [ ] Polish: add sound, animations, and particle-like effects
- [ ] Build a release binary and share it with someone!

---

## 🌐 Stage 9: Intermediate Topics

- [ ] Understand and use `Camera2D` for scrolling worlds
- [ ] Implement a tile-based map / tilemap renderer
- [ ] Load map data from a file or array
- [ ] Add parallax scrolling backgrounds
- [ ] Implement simple enemy AI (patrol, chase, shoot)
- [ ] Manage multiple game objects with arrays or linked lists
- [ ] Explore object pooling for bullets/particles

---

## 🧱 Stage 10: 3D Graphics Basics (Optional Path)

- [ ] Understand the 3D coordinate system and `Camera3D`
- [ ] Draw basic 3D shapes: cubes, spheres, planes
- [ ] Load and display a 3D model with `LoadModel` / `DrawModel`
- [ ] Handle lighting with `SetShapesTexture` and basic raylib shaders
- [ ] Implement first-person or third-person camera movement
- [ ] Build a simple 3D scene or maze

---

## 🛠️ Stage 11: Tools & Ecosystem

- [ ] Explore [raylib extras](https://github.com/raysan5/raylib) and community libraries (raygui, rres, physac)
- [ ] Use **raygui** to add simple UI elements (buttons, sliders, panels)
- [ ] Try **physac** for basic 2D physics
- [ ] Explore Tiled map editor and load `.tmx` maps into raylib
- [ ] Look into **raylib-cpp** or language bindings (Python, Go, Rust, etc.) if desired

---

## 🚀 Stage 12: Finishing & Shipping

- [ ] Profile your game for performance bottlenecks
- [ ] Minimize texture/sound load times
- [ ] Package assets alongside your binary
- [ ] Cross-compile for Windows, Linux, or macOS
- [ ] Explore web export via **Emscripten** (`PLATFORM=PLATFORM_WEB`)
- [ ] Publish to [itch.io](https://itch.io/) or share on [raylib Discord](https://discord.gg/raylib)

---

> **Tip:** Don't rush through stages — build something small and fun at each step. The best way to learn game dev is to _finish_ small games, not start big ones.
