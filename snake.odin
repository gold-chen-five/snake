package snake

import "core:fmt"
import rl "vendor:raylib"

Screen_Width :: 800
Screen_Height :: 450 

Entity_Len :: 10
Direction :: enum {
  Up, 
  Down,
  Left,
  Right
}

Snake :: struct {
  speed: int,
  color: rl.Color,
  direction: Direction,
  using rec: rl.Rectangle
} 

move_snake ::proc(snake: ^Snake) {
   
}

keyboard_detect :: proc() {

}

draw_snake :: proc(snake: ^Snake) {
  rl.DrawRectangleRec(
    rec=snake.rec,
    color=snake.color
  )
}

main :: proc() {
  rl.InitWindow(Screen_Width, Screen_Height, "snake game")
  defer rl.CloseWindow()
  
  rl.SetTargetFPS(60)
  for !rl.WindowShouldClose() {
    rl.BeginDrawing() 
    rl.ClearBackground(rl.GREEN)

    // starting point
    snake := Snake {
      speed=10,
      color=rl.RED,
      direction=Direction.Up,
      x=100,
      y=100,
      width=Entity_Len,
      height=Entity_Len
    }
    draw_snake(&snake)
    move_snake(&snake)
    // keyboard > snake movement 
    // apple and score
    // end game > bite the tail or hit on the wall
    rl.EndDrawing()
  }
}
