extends Node2D
class_name Blaster

const MAX_FIRE_ANGLE : float = 90

@export var projectile_ps : PackedScene




#stats
@export var accuracy : float = 0.5
@export var speed : float = 4 #grid space
@export var max_range : int = 8 #how many spaces we move total

var max_ammo : int = 9
var current_ammo : int 


#0-1
@onready var muzzle_flash : AnimatedSprite2D = $MuzzleFlash
@onready var body_sprite : Sprite2D =  $BodySprite
var recoil_intensity : float = 8
var recoil_time : float = 0.15


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_ammo = max_ammo
	muzzle_flash.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func aim(pos : Vector2):
	look_at(pos)
	global_rotation += deg_to_rad(90)
	if global_rotation < 0:
		body_sprite.flip_v = true
	else:
		body_sprite.flip_v = false

func reload(owner_creature : Creature):
	current_ammo = max_ammo
	reload_animation()
	
func use(owner_creature : Creature):
	if current_ammo < 1:
		current_ammo = 0
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
	new_projectile.speed = speed
	new_projectile.max_range = max_range
	
	$AudioStreamPlayer2D.pitch_scale = randf_range(0.95,1.15)
	$AudioStreamPlayer2D.play()
	
	muzzle_flash.visible = true
	muzzle_flash.play("default")
	kickback(recoil_time)
	
	current_ammo -= 1
	


func _on_muzzle_flash_animation_finished() -> void:
	muzzle_flash.visible = false
	
	
func kickback(kickback_time : float):
	
	var start_pos = body_sprite.position
	var recoil_offset = -body_sprite.transform.x * recoil_intensity
	
	body_sprite.position = recoil_offset
	
	var tween = create_tween()
	
	tween.tween_property(body_sprite, "position", start_pos, kickback_time)
	

func reload_animation():
	var body_start_pos = body_sprite.position
	var tween = create_tween()
	
	tween.tween_property(body_sprite,"position",body_start_pos + Vector2(-6,0), 0.05)
	tween.tween_property(body_sprite,"position",body_start_pos + Vector2(4,0), 0.05)
	tween.tween_property(body_sprite,"position",body_start_pos + Vector2(2,0), 0.05)
	tween.tween_property(body_sprite,"position",body_start_pos + Vector2(0,0), 0.05)
	
	
	
	
	
	
