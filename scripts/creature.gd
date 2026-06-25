extends Area2D
class_name Creature

const CREATURE_SIZE = 31

var game_manager : GameManager

@export var is_player_creature : bool

@export var speed : float = 100
var birth_name : String = "Meepis"
var counter : int = 0

#tracked data
var current_pos : Vector2i
var next_pos: Vector2i

var max_health : int = 3
var current_health : int

#inventory
@export var current_blaster : Blaster



@export var team : String
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

var blaster_ready : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_pos = Vector2i(0,0)
	next_pos = Vector2i(0,0)
	current_health = max_health
	game_manager = get_tree().current_scene.get_node("GameManager")
	if !is_instance_valid(game_manager):
		print("found manager")
	else:
		print("no manager")
	game_manager.register_creature(self)
	animated_sprite.play("idle")
	finalize_unready()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_player_creature:
		return
		
func move_increment(dir : Vector2):
	global_position += dir * CREATURE_SIZE

func move_slide(dir : Vector2):
	global_position += dir.normalized() * speed * get_process_delta_time()

func move(dir : Vector2i) -> bool:
	if !game_manager.can_move_to(current_pos+dir):
		return false
	next_pos += dir
	if dir.x < 0:
		animated_sprite.flip_h = true
	if dir.x > 0:
		animated_sprite.flip_h = false
	animated_sprite.play("walk")
	print(next_pos) 
	unready_blaster()
	return true
	
	
func finalize_move():
	animated_sprite.play("idle")
	current_pos = next_pos

func take_damage(amount : int):
	current_health -= amount
	if current_health <= 0:
		current_health = 0
		print("I've perished D:")
		#get_tree().reload_current_scene()
	
func use_blaster():
	if !blaster_ready:
		ready_blaster()
		return
	if is_instance_valid(current_blaster):
		current_blaster.use(self)

func reload_blaster():
	if is_instance_valid(current_blaster):
		current_blaster.reload(self)
	
func aim_blaster(pos : Vector2):
	if !blaster_ready:
		if animated_sprite.flip_h:
			current_blaster.aim(global_position + Vector2(10,10))
		else:
			current_blaster.aim(global_position + Vector2(-10,10))
		return
	if is_instance_valid(current_blaster):
		current_blaster.aim(pos)
	


func ready_blaster():
	if blaster_ready:
		return
	blaster_ready = true

	var original_pos := current_blaster.position

	var tween := create_tween()
	#current_blaster.bring_out()

	tween.tween_property(
		current_blaster,
		"position",
		original_pos + Vector2(0, -16),
		GameManager.TURN_TIME/2
	)

	await tween.finished

	move_child(current_blaster, get_child_count() - 1)

	var tween2 := create_tween()

	tween2.tween_property(
		current_blaster,
		"position",
		original_pos,
		GameManager.TURN_TIME/2
	)

	
func finalize_unready():
	blaster_ready = false
	move_child(current_blaster, 0)
	
func unready_blaster():
	if !blaster_ready:
		return
	blaster_ready = false
	var original_pos := current_blaster.position
	var tween = create_tween()
	tween.tween_property(
		current_blaster,
		"position",
		original_pos + Vector2(0, -16),
		GameManager.TURN_TIME/2
	)
	
	await tween.finished
	
	move_child(current_blaster, 0)
	
	var tween2 = create_tween()
	
	tween2.tween_property(
		current_blaster,
		"position",
		original_pos,
		GameManager.TURN_TIME/2
	)
	
	
	move_child(current_blaster,0)

	
