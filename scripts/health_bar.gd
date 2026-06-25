extends HBoxContainer
class_name HealthBar

@export var full_color : Color
@export var empty_color : Color

@export var heart_container_ps : PackedScene

func _ready() -> void:
	pass

func set_max_health(max_health : int):
	#go through and delete my existing containers
	#spawn in enough containers to matcht he max health
	for hc in get_children():
		hc.queue_free()
	for i in range(max_health):
		var new_heart = heart_container_ps.instantiate()
		add_child(new_heart)
		
	pass
	
func set_current_health(current_health : int):
	var counter : int = 0
	for hc in get_children():
		if counter < current_health:
			hc.modulate = full_color
		else:
			hc.modulate = empty_color
		counter += 1
	pass
