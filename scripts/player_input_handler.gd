extends Node2D

@export var game_manager : GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	game_manager.player_creature.aim_current_item(get_global_mouse_position())

	if game_manager.taking_turn:
		return
	
	if Input.is_action_just_pressed("reload"):
		game_manager.player_creature.reload_blaster()
		game_manager.take_turn()
		return
	
	if Input.is_action_pressed("use"):
		game_manager.player_creature.use_current_item()
		game_manager.take_turn()
		return
	
	if Input.is_action_pressed("wait"):
		game_manager.player_creature.wait()
		game_manager.take_turn()
	scan_movement()
	scan_inventory()
	
func scan_inventory():
	for i in range(1,10):
		if Input.is_action_just_pressed(str(i)):
			game_manager.player_creature.set_current_item(i-1)
			return

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

	if game_manager.player_creature.move(dir):
		game_manager.take_turn()
	#print(game_manager.player_creature.current_pos, " ", game_manager.player_creature.next_pos)
	

func scan_movement_increment():
	if Input.is_action_just_pressed("up"):
		game_manager.player_creature.move_increment(Vector2(0,-1))	
	if Input.is_action_just_pressed("down"):
		game_manager.player_creature.move_increment(Vector2(0,1))	
	if Input.is_action_just_pressed("left"):
		game_manager.player_creature.move_increment(Vector2(-1,0))	
	if Input.is_action_just_pressed("right"):
		game_manager.player_creature.move_increment(Vector2(1,0))	

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
		game_manager.player_creature.move_slide(dir)	
	
