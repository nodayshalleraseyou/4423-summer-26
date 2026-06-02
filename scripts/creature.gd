extends Area2D
class_name Creature

const CREATURE_SIZE = 31

var game_manager : GameManager

@export var is_player_creature : bool

@export var speed : float = 100
var birth_name : String = "Meepis"
var counter : int = 0



#tracked data
var current_pos : Vector2i
var next_pos: Vector2i

var max_health : int = 3
var current_health : int = 3

#inventory
@export var current_blaster : Blaster



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_pos = Vector2i(0,0)
	next_pos = Vector2i(0,0)
	
	game_manager = get_tree().current_scene.get_node("GameManager")
	game_manager.register_creature(self)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_player_creature:
		return
		
func move_increment(dir : Vector2):
	global_position += dir * CREATURE_SIZE

func move_slide(dir : Vector2):
	global_position += dir.normalized() * speed * get_process_delta_time()

func move(dir : Vector2i):
	next_pos += dir
	print(next_pos)
	
	
func finalize_move():
	current_pos = next_pos

func take_damage(amount : int):
	current_health -= amount
	if current_health <= 0:
		current_health = 0
		print("I've perished D:")
		#get_tree().reload_current_scene()
	
func use_blaster():
	if is_instance_valid(current_blaster):
		current_blaster.use()
	
	
