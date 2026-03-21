package snake

import "core:fmt"
import rl "vendor:raylib"

Screen_Width :: 800
Screen_Height :: 600 
Playground_Width :: 800
Playground_Height :: 600

MOVE_INTERVAL :: 0.1  

Direction :: enum u8 {
  Up, 
  Down,
  Left,
  Right
}

Snake :: struct {
  speed: f32,
  color: rl.Color,
  direction: Direction,
  body: [dynamic]rl.Rectangle 
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
  for i:=len(snake.body)-1; i>0; i-=1 {
    snake.body[i] = snake.body[i-1]  
  }
  switch snake.direction {
  case .Up: snake.body[0].y -= Entity_Len 
  case .Down: snake.body[0].y += Entity_Len
  case .Right: snake.body[0].x += Entity_Len
  case .Left: snake.body[0].x -= Entity_Len
  }
}

main :: proc() {
  rl.InitWindow(Screen_Width, Screen_Height, "snake game")
  defer rl.CloseWindow()

  // setup
  rl.SetTargetFPS(10)
  snake := Snake {
    speed=80,
    color=rl.RED,
    direction=.Right,
    body=make([dynamic]rl.Rectangle)
  }
  defer delete(snake.body)

  append(&snake.body, rl.Rectangle{
      x=20,
      y=20,
      width=Entity_Len,
      height=Entity_Len
  })

  apple := entity_create_apple() 

  move_timer: f32
  for !rl.WindowShouldClose() {
    // keyboard
    switch {
    case rl.IsKeyPressed(.UP): snake.direction = .Up
    case rl.IsKeyPressed(.DOWN): snake.direction = .Down
    case rl.IsKeyPressed(.RIGHT): snake.direction = .Right 
    case rl.IsKeyPressed(.LEFT): snake.direction = .Left
    }

    // move
    snake_move(&snake)

    // apple and score
    if entity_touch_target(&snake, apple) {
      apple = entity_create_apple()
    }
    
    rl.BeginDrawing() 
    rl.ClearBackground(rl.GREEN)
    entity_draw_target(apple)
    snake_draw(snake)
    rl.EndDrawing()
  }
}
