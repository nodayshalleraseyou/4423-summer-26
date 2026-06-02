extends Node2D

@export var player_creature : Creature
@export var game_manager : GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_manager.taking_turn:
		return
	
	if Input.is_action_just_pressed("use"):
		player_creature.use_blaster()
	scan_movement()


func scan_movement():
	var dir : Vector2 = Vector2.ZERO
	if Input.is_action_pressed("up"):
		dir += Vector2(0,-1)
	if Input.is_action_pressed("down"):
		dir += Vector2(0,1)
	if Input.is_action_pressed("left"):
		dir += Vector2(-1,0)
	if Input.is_action_pressed("right"):
		dir += Vector2(1,0)
	if dir == Vector2.ZERO:
		return
	player_creature.move(dir)
	game_manager.take_turn()

	

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
	
