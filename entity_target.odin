package snake

import rl "vendor:raylib"
import "core:math/rand"

Entity_Len :: 20 

Entity :: struct {
  using rec: rl.Rectangle,
  color: rl.Color
}

Apple :: struct { using entity: Entity }

Entity_Target :: union {
  Apple
}

entity_create_apple :: proc() -> Apple {
  whi : i32 = Playground_Width / Entity_Len -1
  hhi : i32 = Playground_Height / Entity_Len -1
  x := rand.int32_range(0, whi) * Entity_Len 
  y := rand.int32_range(0, hhi) * Entity_Len 

  return Apple{
    x=f32(x),
    y=f32(y),
    width=Entity_Len,
    height=Entity_Len,
    color=rl.DARKPURPLE
  } 
}

entity_draw_target :: proc(target: Entity_Target) {
  switch t in target {
  case Apple:
    rl.DrawRectangleRec(
      rec=t.rec,
      color=t.color
    )
  }
}

entity_touch_target :: proc(snake: ^Snake, target: Entity_Target) -> bool {
  tail := snake.body[len(snake.body)-1]
  switch t in target{ 
  case Apple:
     if rl.CheckCollisionRecs(snake.body[0], t.rec){
        append(&snake.body, tail) 
        return true
     }   
  }
  return false
}
