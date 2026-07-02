extends Node2D

@export var game_manager : GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if !is_instance_valid(game_manager.player_creature.current_item):
		#return
	#
	#var max_angle : float = \
	#game_manager.player_creature.current_blaster.accuracy * Blaster.MAX_FIRE_ANGLE
	#global_position = game_manager.player_creature.global_position
	#global_rotation = game_manager.player_creature.current_blaster.global_rotation
	#$LeftPivot.rotation = -deg_to_rad(max_angle)
	#$RightPivot.rotation = deg_to_rad(max_angle)
