extends Node2D
class_name GameManager

@export var projectile_manager : ProjectileManager
@export var camera : Camera2D
@export var player_creature : Creature

const GRID_DIM = 17
const GRID_CELL_SIZE = 31
const TURN_TIME : float = 0.25


var ai_array : Array = []
var creature_dict : Dictionary[Vector2i, Creature] = {}

var taking_turn : bool = false
var timer_value : float = 0.0


#current zone info
@export var current_zone : Zone
var last_zone : Zone



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_ais()
	if taking_turn:
		timer_value += delta
		slide_creatures(timer_value/TURN_TIME)
		projectile_manager.process_projectiles_for_turn(delta)
		if timer_value >= TURN_TIME:
			timer_value = 0
			end_turn()
		

func update_ais():
	for ai in ai_array:
		if is_instance_valid(ai):
			ai.update_ai()

	
func take_turn():
	try_zone_swap()
	if camera.global_position != current_zone.global_position:
		shift_camera()
	for ai in ai_array:
		if is_instance_valid(ai):
			ai.take_turn()
	taking_turn = true

func end_turn():
	var new_creature_dict : Dictionary[Vector2i, Creature] = {}
	for c in creature_dict.values():
		c.finalize_move()
		c.global_position = cell_to_world(c.next_pos)
		new_creature_dict[c.current_pos] = c
	taking_turn = false
	creature_dict = new_creature_dict
	if is_instance_valid(last_zone):
		last_zone.queue_free()

	

func slide_creatures(percentage : float):
	for c in creature_dict.values():
		c.global_position = lerp(
				cell_to_world(c.current_pos), cell_to_world(c.next_pos), percentage
			)

func register_creature(creature : Creature):
	print("creature added!")
	creature.current_pos = creature.global_position / GRID_CELL_SIZE
	creature.next_pos = creature.current_pos

	if creature_dict.has(creature.current_pos):
		print("WARNING CREATURE REPLACED IN DICTIONARY!")
	creature_dict[creature.current_pos] = creature
	

func cell_to_world(cell_coord : Vector2i) -> Vector2:
	return Vector2(cell_coord.x*GRID_CELL_SIZE, cell_coord.y*GRID_CELL_SIZE)

func world_to_cell(world_pos : Vector2) -> Vector2i:
	return Vector2i(world_pos.x/GRID_CELL_SIZE,world_pos.y/GRID_CELL_SIZE)

#returns true if the move is valid
func can_move_to(cell_coord : Vector2i) -> bool:
	if creature_dict.has(cell_coord):
		return false
	
	#var tile_data = current_zone.wall_layer.get_cell_tile_data(cell_coord)	
	#if is_instance_valid(tile_data):
		#return false
	
	var creature_global_pos : Vector2 = cell_coord * GRID_CELL_SIZE
	var tile_grid_pos : Vector2i = current_zone.wall_layer.local_to_map(current_zone.wall_layer.to_local(creature_global_pos))
	var tile_data = current_zone.wall_layer.get_cell_tile_data(tile_grid_pos)
	if is_instance_valid(tile_data):
		return false
	return true

func register_ai(new_ai : Node2D):
	ai_array.append(new_ai)

func find_nearest_target(searching_creature : Creature) -> Creature:
	var min_dist : float = 1000000
	var best_target : Creature = null
	for c in creature_dict.values():
		if c == searching_creature:
			continue
		if c.team == searching_creature.team:
			continue
		var new_dist : float  = c.global_position.distance_squared_to(searching_creature.global_position)
		if  new_dist < min_dist:
			min_dist = new_dist	
			best_target = c
	return best_target


func try_zone_swap():
	var zone_center : Vector2i = world_to_cell(current_zone.global_position)
	var left_grid_x = zone_center.x - GRID_DIM/2
	var right_grid_x = zone_center.x + GRID_DIM/2
	var up_grid_y = zone_center.y - GRID_DIM/2
	var down_grid_y = zone_center.y + GRID_DIM/2
	if player_creature.next_pos.x < left_grid_x:
		zone_swap(Vector2i(-1,0), current_zone.left_zone)
	if player_creature.next_pos.x > right_grid_x:
		zone_swap(Vector2i(1,0), current_zone.right_zone)
	if player_creature.next_pos.y < up_grid_y:
		zone_swap(Vector2i(0,-1), current_zone.up_zone)
	if player_creature.next_pos.y > down_grid_y:
		zone_swap(Vector2i(0,1), current_zone.down_zone)

func zone_swap(dir : Vector2, zone_name : String):
	var packed_zone : PackedScene = load("res://zones/" + zone_name + ".tscn")
	
	creature_dict = {}
	ai_array = []
	creature_dict[player_creature.current_pos] = player_creature
	
	var new_zone = packed_zone.instantiate() 
	new_zone.global_position = current_zone.global_position + dir * GRID_DIM * GRID_CELL_SIZE
	get_tree().current_scene.add_child(new_zone)
	
	var current_zone_index : int = current_zone.get_index()
	get_tree().current_scene.move_child(new_zone,current_zone_index)
	last_zone = current_zone
	current_zone = new_zone

		
func shift_camera():
	var tween = create_tween()\
		.set_ease(Tween.EASE_IN_OUT)\
		.set_trans(Tween.TRANS_SINE)
	
	tween.tween_property(camera, "global_position", current_zone.global_position, TURN_TIME)
	


	
