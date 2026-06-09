extends Area2D
class_name Projectile

@export var damage : int = 1
var my_creature : Creature

var speed : float = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(check_hit)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func check_hit(area : Area2D):
	print("hit something!")
	if area is Creature:
		if area != my_creature:
			area.take_damage(damage)

func update_for_turn(delta : float):
	global_position += -global_transform.y * speed * GameManager.GRID_CELL_SIZE	 * delta	





		
		
		
		
		
		
		
