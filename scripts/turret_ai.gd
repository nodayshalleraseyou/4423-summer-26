extends Node2D
class_name TurretAI

var my_creature : Creature
var target_creature : Creature
var game_manager : GameManager



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	my_creature = get_parent()
	game_manager = get_tree().current_scene.get_node("GameManager")
	game_manager.register_ai(self)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
#for things the ai needs to do each frame
func update_ai():
	if is_instance_valid(target_creature):
		my_creature.aim_blaster(target_creature.global_position)
	

func take_turn():
	target_creature = game_manager.find_nearest_target(my_creature)
	if !is_instance_valid(target_creature):
		return
	my_creature.aim_blaster(target_creature.global_position)
	my_creature.use_blaster()
