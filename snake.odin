package snake

import "core:fmt"
import rl "vendor:raylib"

Screen_Width :: 800
Screen_Height :: 600 
Entity_Len :: 15 

Direction :: enum u8 {
  Up, 
  Down,
  Left,
  Right
}

Snake :: struct {
  using rec: rl.Rectangle,
  speed: f32,
  color: rl.Color,
  direction: Direction,
} 

draw_snake :: proc(snake: Snake) {
  rl.DrawRectangleRec(
    rec=snake.rec,
    color=snake.color
  )
}

move_snake ::proc(snake: ^Snake) {
  dt := rl.GetFrameTime()
  switch snake.direction {
  case .Up: snake.y -= (snake.speed * dt)
  case .Down: snake.y += (snake.speed * dt)
  case .Right: snake.x += (snake.speed * dt)
  case .Left: snake.x -= (snake.speed * dt)
  }  
}

keyboard_detect :: proc(snake: ^Snake) {
  switch {
  case rl.IsKeyDown(.UP): snake.direction = .Up
  case rl.IsKeyDown(.DOWN): snake.direction = .Down
  case rl.IsKeyDown(.RIGHT): snake.direction = .Right
  case rl.IsKeyDown(.LEFT): snake.direction = .Left
  }
}

Apple :: struct {
  using rec: rl.Rectangle,
  color: rl.Color
}

Target :: union {
  Apple
}

draw_target :: proc(target: Target){
  switch t in target {
  case Apple:
    rl.DrawRectangleRec(
      rec=t.rec,
      color=t.color
    )
  }
}

main :: proc() {
  rl.InitWindow(Screen_Width, Screen_Height, "snake game")
  defer rl.CloseWindow()

  // setup
  rl.SetTargetFPS(60)
  snake := Snake {
    speed=80,
    color=rl.RED,
    direction=.Right,
    x=100,
    y=100,
    width=Entity_Len,
    height=Entity_Len
  }

  for !rl.WindowShouldClose() {
    rl.BeginDrawing() 
    rl.ClearBackground(rl.GREEN)

    // starting point
    draw_snake(snake)
    move_snake(&snake)

    // keyboard > snake movement 
    keyboard_detect(&snake) 

    // apple and score
    apple := Apple{
      x=160,
      y=100,
      width=Entity_Len,
      height=Entity_Len,
      color=rl.DARKPURPLE
    } 
    draw_target(apple)

    // end game > bite the tail or hit on the wall
    rl.EndDrawing()
  }
}
