extends Node2D

@export var player_creature : Creature

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_instance_valid(player_creature.current_blaster):
		return
	
	var max_angle : float = \
	player_creature.current_blaster.accuracy * Blaster.MAX_FIRE_ANGLE
	global_position = player_creature.global_position
	global_rotation = player_creature.current_blaster.global_rotation
	$LeftPivot.rotation = -deg_to_rad(max_angle)
	$RightPivot.rotation = deg_to_rad(max_angle)
