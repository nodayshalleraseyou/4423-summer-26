extends Node2D
class_name Blaster

const MAX_FIRE_ANGLE : float = 90

@export var projectile_ps : PackedScene

@export var accuracy : float = 0.5

#0-1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func aim(pos : Vector2):
	look_at(pos)
	global_rotation += deg_to_rad(90)

func use(owner_creature : Creature):
	var new_projectile : Projectile = projectile_ps.instantiate() as Projectile
	var projectile_manager = get_tree().current_scene.get_node("ProjectileManager")
	projectile_manager.add_child(new_projectile)
	projectile_manager.register_projectile(new_projectile)
	new_projectile.global_position = $SpawnPoint.global_position
	new_projectile.global_rotation = global_rotation
	new_projectile.global_rotation += \
	randf_range(-1,1) * deg_to_rad(MAX_FIRE_ANGLE) * (1-accuracy)
	new_projectile.my_creature = owner_creature
	
	
	
	
	
	
	
