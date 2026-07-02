extends Area2D
class_name Creature

const CREATURE_SIZE = 31

var game_manager : GameManager
@export var is_player_creature : bool

#Stats
var birth_name : String = "Meepis"
var current_pos : Vector2i
var next_pos: Vector2i
var max_health : int = 3
var current_health : int = 3
var perished : bool = false

#inventory
@export var current_item : Blaster
@export var team : String
var inventory : Array[Item] = []


@export_group("Animations")
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var torso_sprite : Sprite2D = $TorsoSprite
@onready var head_sprite : Sprite2D = $HeadSprite
@onready var animation_player : AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_pos = Vector2i(0,0)
	next_pos = Vector2i(0,0)
	
	game_manager = get_tree().current_scene.get_node("GameManager")
	game_manager.register_creature(self)
	animated_sprite.play("idle")
	animation_player.play("idle")
	init_inventory()
	
func init_inventory():
	for item in $Inventory.get_children():
		inventory.append(item)
		item.visible = false
	if inventory.size() > 0:
		current_item = inventory[0]
		current_item.equip(self)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_player_creature:
		return
		
func move_increment(dir : Vector2):
	global_position += dir * CREATURE_SIZE

func move_slide(dir : Vector2):
	global_position += dir.normalized() * 1 * get_process_delta_time()

func move_to(pos : Vector2i) -> bool:
	var move_dir : Vector2i = pos - current_pos
	return move(move_dir)
	

func move(dir : Vector2i) -> bool:
	if dir.x != 0 and dir.y != 0:
		return false #no diagonal moves
	if dir == Vector2i.ZERO:
		return false #no no moves
	if !game_manager.can_move_to(current_pos+dir):
		return false #no bad bad moves moves
	next_pos += dir
	game_manager.submit_planned_move(next_pos, self)
	var frames : int = animated_sprite.sprite_frames.get_frame_count("walk")
	animated_sprite.sprite_frames.set_animation_speed("walk", frames / GameManager.TURN_TIME )
	animated_sprite.play("walk")
	animation_player.play("walk")
	if dir.x < 0:
		animated_sprite.flip_h = true
		torso_sprite.flip_h = true
		head_sprite.flip_h = true
	if dir.x > 0:
		animated_sprite.flip_h = false
		torso_sprite.flip_h = false
		head_sprite.flip_h = false
	for item in inventory:
		item.on_move(self)
	return true
		
	
func finalize_move():
	current_pos = next_pos
	animated_sprite.play("idle")
	animation_player.play("idle")

func take_damage(amount : int):
	current_health -= amount
	if current_health <= 0:
		current_health = 0
		print("I've perished D:")
		perished = true
	
func heal(amount : int):
	current_health += amount
	if current_health > max_health:
		current_health = max_health


func use_current_item():
	if !current_item.is_ready:
		current_item.ready_blaster()
		return
	if is_instance_valid(current_item):
		current_item.use(self)
		
func aim_current_item(pos : Vector2):
	if is_instance_valid(current_item):
		current_item.aim(pos, self)
	
func set_current_item(index : int):
	if index >= inventory.size():
		return
	if current_item == inventory[index]:
		return
	current_item.dequip(self)
	current_item = inventory[index]
	current_item.equip(self)

func set_current_item_direct(item : Item):
	current_item.dequip(self)
	current_item = item
	current_item.equip(self)

func reload_blaster():
	if is_instance_valid(current_item):
		current_item.reload()

func wait():
	pass
