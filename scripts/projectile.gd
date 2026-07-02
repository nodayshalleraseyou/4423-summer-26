extends Area2D
class_name Projectile

@export var damage : int = 1
var my_creature : Creature

var max_turns : int = 2
var turn_tracker : float = 0
var speed : float = 10

var start_pos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(check_creature_hit)
	body_entered.connect(check_wall_hit)

# Called every frame. 'delta' is the elapsed time since the previous frame.tt
func _process(delta: float) -> void:
	pass

func check_creature_hit(area : Area2D):
	if area is Creature:
		if area != my_creature:
			area.take_damage(damage)
			queue_free()

func update_for_turn(delta : float):
	global_position += -global_transform.y * speed * GameManager.GRID_CELL_SIZE	 * delta / GameManager.TURN_TIME	

func reached_max_dist() -> bool:
	return turn_tracker >= max_turns

func end_turn():
	turn_tracker += 1

func check_wall_hit(body : Node2D):
	print("CHECK WALL HIT")
	queue_free()
