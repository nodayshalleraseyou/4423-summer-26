extends Node2D
class_name ProjectileManager
var projectile_array : Array[Projectile] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func process_projectiles_for_turn(delta : float):
	for p in projectile_array:
		p.update_for_turn(delta)
	pass

func register_projectile(new_projectile : Projectile):
	projectile_array.append(new_projectile)
