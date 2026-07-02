extends Item
class_name UsesItem
@export_category("Uses Item")
@export var max_uses : int = 1
var current_uses : int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func use(owner_creature : Creature):
	if current_uses < 1:
		current_uses = 0
		return
	current_uses -= 1

func use_uses_item(owner_creature : Creature):
	pass
