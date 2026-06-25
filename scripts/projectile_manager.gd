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
	for i in range(projectile_array.size()-1, -1, -1):
		if !is_instance_valid(projectile_array[i]):
			projectile_array.remove_at(i)
			i+=1
			continue
		projectile_array[i].update_for_turn(delta)
		if projectile_array[i].reached_max_dist():
			projectile_array[i].queue_free()
			projectile_array.remove_at(i)
			i+=1
	#for p in projectile_array:
		#p.update_for_turn(delta)



func register_projectile(new_projectile : Projectile):
	projectile_array.append(new_projectile)
