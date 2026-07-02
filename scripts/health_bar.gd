extends HBoxContainer
class_name HealthBar


@export var on_color : Color
@export var off_color : Color

@export var heart_container_ps : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed tsime since the previous frame.
func _process(delta: float) -> void:
	pass

func setup(max_health : int):
	for i in range(max_health):
		var new_heart = heart_container_ps.instantiate()
		add_child(new_heart) 
		
	
func update_health_bar(current_health : int):
	var counter : int = 0
	for container in get_children():
		if counter < current_health:
			container.modulate = on_color
		else:
			container.modulate = off_color
		counter+=1
		
