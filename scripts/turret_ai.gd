extends AI
class_name AITurret

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

func take_turn():
	target_creature = game_manager.find_nearest_target(my_creature)
	if !is_instance_valid(target_creature):
		return
	if my_creature.current_blaster.current_ammo > 0:
		my_creature.aim_blaster(target_creature.global_position)
		my_creature.use_blaster()
