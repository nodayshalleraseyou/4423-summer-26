extends Sprite2D
class_name Blaster

@export var projectile_ps : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func use():
	var new_projectile : Projectile = projectile_ps.instantiate() as Projectile
	var projectile_manager = get_tree().current_scene.get_node("ProjectileManager")
	projectile_manager.add_child(new_projectile)
	if is_instance_valid(new_projectile):
		print("Valid!")
	new_projectile.global_position = global_position
