package snake

import "core:fmt"
import "core:math/rand"
import rl "vendor:raylib"

Screen_Width :: 800
Screen_Height :: 600 
Entity_Len :: 20 

Direction :: enum u8 {
  Up, 
  Down,
  Left,
  Right
}

Snake_Block :: struct {
  using rec: rl.Rectangle,
  direction: Direction,
}

Snake :: struct {
  speed: f32,
  color: rl.Color,
  body: [dynamic]Snake_Block 
} 

snake_draw :: proc(snake: Snake) {
  for rec in snake.body {
    rl.DrawRectangleRec(
      rec=rec,
      color=snake.color
    )
  }
}

snake_move ::proc(snake: ^Snake) {
  dt := rl.GetFrameTime()
  for &sb in snake.body {
    switch sb.direction {
    case .Up: sb.y -= (snake.speed * dt)
    case .Down: sb.y += (snake.speed * dt)
    case .Right: sb.x += (snake.speed * dt)
    case .Left: sb.x -= (snake.speed * dt)
    }
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
    body=make([dynamic]Snake_Block)
  }
  defer delete(snake.body)
  
  append(&snake.body, Snake_Block{
    direction=.Right,
    rec=rl.Rectangle{
        x=20,
        y=20,
        width=Entity_Len,
        height=Entity_Len
    }
  })

  kds := make(Keyboard_Detects)

  apple := Apple{
    x=160,
    y=100,
    width=Entity_Len,
    height=Entity_Len,
    color=rl.DARKPURPLE
  } 

  for !rl.WindowShouldClose() {
    rl.BeginDrawing() 
    rl.ClearBackground(rl.GREEN)

    entity_draw_target(apple)

    // starting point
    snake_draw(snake)
    snake_move(&snake)

    // keyboard > snake movement 
    keyboard_detect(&kds, snake.body[0]) 
    keyboard_check_detects(&snake, kds) 

    // apple and score
    entity_touch_target(&snake, apple)

    // end game > bite the tail or hit on the wall
    rl.EndDrawing()
  }
}
