extends Node2D

@export var player_creature : Creature

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scan_movement_slide()

func scan_movement_increment():
	if Input.is_action_just_pressed("up"):
		player_creature.move_increment(Vector2(0,-1))	
	if Input.is_action_just_pressed("down"):
		player_creature.move_increment(Vector2(0,1))	
	if Input.is_action_just_pressed("left"):
		player_creature.move_increment(Vector2(-1,0))	
	if Input.is_action_just_pressed("right"):
		player_creature.move_increment(Vector2(1,0))	

func scan_movement_slide():
	var dir : Vector2 = Vector2.ZERO
	if Input.is_action_pressed("up"):
		dir += Vector2(0,-1)	
	if Input.is_action_pressed("down"):
		dir += Vector2(0,1)
	if Input.is_action_pressed("left"):
		dir += Vector2(-1,0)
	if Input.is_action_pressed("right"):
		dir += Vector2(1,0)
	if dir != Vector2.ZERO:
		player_creature.move_slide(dir)	
	
