package snake

import rl "vendor:raylib"

Entity :: struct {
  using rec: rl.Rectangle,
  color: rl.Color
}

Apple :: struct { using entity: Entity }

Entity_Target :: union {
  Apple
}

entity_create_apple :: proc(){

}

entity_draw_target :: proc(target: Entity_Target){
  switch t in target {
  case Apple:
    rl.DrawRectangleRec(
      rec=t.rec,
      color=t.color
    )
  }
}

entity_touch_target :: proc(snake: ^Snake, target: Entity_Target){
  switch t in target{ 
  case Apple:
     if rl.CheckCollisionRecs(snake.body[0].rec, t.rec){
        tail := snake.body[len(snake.body) - 1]
        new_rec := tail.rec
        switch tail.direction {
        case .Right: new_rec.x -= Entity_Len
        case .Left:  new_rec.x += Entity_Len
        case .Up:    new_rec.y += Entity_Len
        case .Down:  new_rec.y -= Entity_Len
        }
        append(&snake.body, Snake_Block{ 
          rec=new_rec, 
          direction=tail.direction
        }) 
     }   
  }
}
