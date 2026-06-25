extends CanvasLayer
class_name PlayerHUD

var game_manager : GameManager

@export var ammo_counter : AmmoCounter 
@export var health_bar : HealthBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().current_scene.get_node("GameManager")
	health_bar = $Control/HealthBar
	health_bar.set_max_health(game_manager.player_creature.max_health)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_creature : Creature = game_manager.player_creature
	ammo_counter.set_ammo_count(player_creature.current_blaster.current_ammo,player_creature.current_blaster.max_ammo)
	health_bar.set_current_health(player_creature.current_health)
