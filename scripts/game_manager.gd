extends Node2D
class_name GameManager

const GRID_CELL_SIZE = 31
const TURN_TIME : float = 0.15

var creature_array : Array[Creature]  = []

var taking_turn : bool = false
var timer_value : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if taking_turn:
		timer_value += delta
		slide_creatures(timer_value/TURN_TIME)
		if timer_value >= TURN_TIME:
			timer_value = 0
			end_turn()
	
func take_turn():
	taking_turn = true

func end_turn():
	for c in creature_array:
		c.finalize_move()
		c.global_position = cell_to_world(c.next_pos)
	taking_turn = false

func slide_creatures(percentage : float):
	for c in creature_array:
		c.global_position = lerp(
				cell_to_world(c.current_pos), cell_to_world(c.next_pos), percentage
			)

func register_creature(creature : Creature):
	print("creature added!")
	creature_array.append(creature)

func cell_to_world(cell_coord : Vector2i) -> Vector2:
	return Vector2(cell_coord.x*GRID_CELL_SIZE, cell_coord.y*GRID_CELL_SIZE)
