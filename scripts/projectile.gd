extends Area2D
class_name Projectile

@export var damage : int = 1
var my_creature : Creature

var speed : float = 10
var max_range : int = 8 #how many spaces we move total
var dist_tracker : float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(check_creature_hit)
	body_entered.connect(check_wall_hit)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func check_creature_hit(area : Area2D):
	print("hit something!")
	if area is Creature:
			if area != my_creature:
				area.take_damage(damage)

func update_for_turn(delta : float):
	global_position += -global_transform.y * speed * GameManager.GRID_CELL_SIZE	 * delta
	dist_tracker += speed * delta	


func reached_max_dist() -> bool:
	return dist_tracker >= max_range
		
func check_wall_hit(body : Node2D):
	queue_free()

		
		
		
		
