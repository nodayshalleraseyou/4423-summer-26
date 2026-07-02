extends Node
class_name ItemAI


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var target_creature : Creature
var path : Array[Vector2i] = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# returns a value between 0 and 1 measuring confidence of action
func make_bid(ai : AI, creature : Creature, game_manager : GameManager) -> float:
	return 0

# completes an action, returns true to reserve an additional turn
func take_action(ai : AI, creature : Creature, game_manager : GameManager) -> bool:
	return false
