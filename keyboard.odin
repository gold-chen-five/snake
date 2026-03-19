package snake

import rl "vendor:raylib"

Keyboard_Detect :: struct {
  x: f32,
  y: f32,
  direction: Direction
}

Keyboard_Detects :: [dynamic]Keyboard_Detect

keyboard_detect :: proc(detects: ^Keyboard_Detects, head_snake_block: Snake_Block){
  switch {
  case rl.IsKeyDown(.UP): 
    append(detects, Keyboard_Detect{ head_snake_block.x, head_snake_block.y, .Up })
  case rl.IsKeyDown(.DOWN): 
    append(detects, Keyboard_Detect{ head_snake_block.x, head_snake_block.y, .Down}) 
  case rl.IsKeyDown(.RIGHT): 
    append(detects, Keyboard_Detect{ head_snake_block.x, head_snake_block.y, .Right})
  case rl.IsKeyDown(.LEFT): 
    append(detects, Keyboard_Detect{ head_snake_block.x, head_snake_block.y, .Left})
  }
}

keyboard_check_detects :: proc(snake: ^Snake, detects: Keyboard_Detects){
  for &sb in snake.body {
    for d in detects {
      if sb.x == d.x && sb.y == d.y {
        sb.direction = d.direction
      }
    } 
  }
} 
