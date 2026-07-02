extends Item
class_name Blaster

const MAX_FIRE_ANGLE : float = 90

@export var projectile_ps : PackedScene

#stats
@export_category("Stats")
@export var accuracy : float = 0.5
@export var shots : int = 1
@export var projectiles_per_shot : int = 1 
var current_ammo : int
@export var max_ammo : int = 9
@export var max_mags : int = 3
var current_mags : int = 3
@export var projectile_turn_lifetime : int = 3 #how many turns
@export var projectile_speed : float = 1 #how many spaces per turn




#visuals
@onready var muzzle_flash : AnimatedSprite2D = $MuzzleFlash
@onready var body_sprite : Sprite2D = $BodySprite
var body_sprite_start_pos: Vector2

# Audio
@export var shoot_sound : AudioStream
@export var no_ammo_sound : AudioStream
@export var equip_sound : AudioStream
@export var reload_sound : AudioStream
@export var low_shoot_pitch : float = 0.8
@export var high_shoot_pitch : float = 1.2
@onready var audio_pool : AudioPool = get_tree().current_scene.get_node("AudioPool")


# Animation
var kickback_tween : Tween

#Ready / Unready
var is_ready : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_ammo = max_ammo
	current_mags = max_mags
	muzzle_flash.visible = false
	body_sprite_start_pos = body_sprite.position
	finalize_unready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func aim(pos : Vector2, creature : Creature):
	if !self.is_ready:	
		if creature.animated_sprite.flip_h:
			look_at(global_position + Vector2(10,10))
		else:
			look_at(global_position + Vector2(-10,10))
	else:	
		look_at(pos)
	global_rotation += deg_to_rad(90)
	if global_rotation < 0:
		body_sprite.flip_v = true
	else:
		body_sprite.flip_v = false
		

func reload():
	if current_mags < 1:
		return
	current_mags -= 1
	audio_pool.play_begin_turn_sound(reload_sound,1,1, 0.15)
	current_ammo = max_ammo
	reload_animation()

func reload_animation():
	body_sprite.position = body_sprite_start_pos

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(body_sprite, "position", body_sprite_start_pos + Vector2(-6,0), 0.05)
	tween.tween_property(body_sprite, "position", body_sprite_start_pos + Vector2(4,0), 0.06)
	tween.tween_property(body_sprite, "position", body_sprite_start_pos + Vector2(-3,0), 0.06)
	tween.tween_property(body_sprite, "position", body_sprite_start_pos + Vector2(2,0), 0.06)
	tween.tween_property(body_sprite, "position", body_sprite_start_pos, 0.08)

func use(owner_creature : Creature):
	for i in range(shots):
		if current_ammo == 0 :
			shoot(owner_creature)
			break
		shoot(owner_creature)
		await await get_tree().create_timer(GameManager.TURN_TIME / shots).timeout			

func shoot(owner_creature : Creature):
	if current_ammo < 1:
		audio_pool.play_begin_turn_sound(no_ammo_sound,1,1)	
		return
	var new_projectile : Projectile = projectile_ps.instantiate() as Projectile
	var projectile_manager = get_tree().current_scene.get_node("ProjectileManager")
	projectile_manager.add_child(new_projectile)
	projectile_manager.register_projectile(new_projectile)
	new_projectile.global_position = $SpawnPoint.global_position
	new_projectile.global_rotation = global_rotation
	new_projectile.global_rotation += \
	randf_range(-1,1) * deg_to_rad(MAX_FIRE_ANGLE) * (1-accuracy)
	new_projectile.my_creature = owner_creature
	new_projectile.max_turns = projectile_turn_lifetime
	new_projectile.speed = projectile_speed
	new_projectile.start_pos = $SpawnPoint.global_position
	current_ammo -= 1
	muzzle_flash.visible = true
	muzzle_flash.play()
	kickback_animation(GameManager.TURN_TIME/shots)
	audio_pool.play_begin_turn_sound(shoot_sound,low_shoot_pitch,high_shoot_pitch)	

	
func _on_muzzle_flash_animation_finished() -> void:
	muzzle_flash.visible = false

func bring_out():
	audio_pool.play_begin_turn_sound(equip_sound,1,1,.5)	
	
func put_away():
	audio_pool.play_begin_turn_sound(equip_sound,.8,.8,.5)	

func kickback_animation(kickback_time : float):
	if kickback_tween and kickback_tween.is_valid():
		kickback_tween.kill()

	var recoil_offset = body_sprite.transform.x * -16

	body_sprite.position = body_sprite_start_pos + recoil_offset

	kickback_tween = create_tween()
	kickback_tween.set_ease(Tween.EASE_OUT)
	kickback_tween.set_trans(Tween.TRANS_EXPO)
	kickback_tween.tween_property(body_sprite, "position", body_sprite_start_pos, kickback_time)

func get_projectile_range() -> float:
	return (projectile_speed  * projectile_turn_lifetime) + 1


func ready_blaster():
	if is_ready:
		return
	is_ready = true

	var original_pos := position
	var parent = get_parent()

	var tween := create_tween()
	bring_out()

	tween.tween_property(
		self,
		"position",
		original_pos + Vector2(0, -16),
		GameManager.TURN_TIME/2
	)

	await tween.finished

	body_sprite.z_index = DrawOrder.ITEM_IN_HANDS
	var tween2 := create_tween()

	tween2.tween_property(
		self,
		"position",
		original_pos,
		GameManager.TURN_TIME/2
	)

func unready_blaster():
	if !is_ready:
		return
	is_ready = false
	var original_pos := position
	var tween = create_tween()
	put_away()
	tween.tween_property(
		self,
		"position",
		original_pos + Vector2(0, -16),
		GameManager.TURN_TIME/2
	)

	await tween.finished

	body_sprite.z_index = DrawOrder.ITEM_ON_BACK
	var tween2 = create_tween()

	tween2.tween_property(
		self,
		"position",
		original_pos,
		GameManager.TURN_TIME/2
	)

func finalize_unready():
	is_ready = false
	body_sprite.z_index = DrawOrder.ITEM_ON_BACK

func on_move(creature : Creature):
	if creature.current_item == self:
		unready_blaster()

func on_equip(creature : Creature):
	self.visible = true
	aim(global_position, creature)

func on_dequip(creature : Creature):
	self.visible = false
	finalize_unready()
