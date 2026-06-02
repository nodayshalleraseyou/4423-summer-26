extends Sprite2D
class_name Creature

const CREATURE_SIZE = 31

@export var is_player_creature : bool

var max_health : int = 10
@export var speed : float = 100
var birth_name : String = "Meepis"

var counter : int = 0

@export var projectile_ps : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_player_creature:
		return
		
func move_increment(dir : Vector2):
	global_position += dir * CREATURE_SIZE

func move_slide(dir : Vector2):
	global_position += dir.normalized() * speed * get_process_delta_time()

	
	
	
	
	
	
	
	
