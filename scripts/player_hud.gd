extends CanvasLayer

@export var game_manager : GameManager

@export var ammo_label : Label

@export var health_bar : HealthBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.setup(game_manager.player_creature.max_health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_manager.player_creature.current_item is not Blaster:
		return
	ammo_label.text = str(game_manager.player_creature.current_item.current_ammo)\
	 + "/" + str(game_manager.player_creature.current_item.max_ammo)
	
	health_bar.update_health_bar(game_manager.player_creature.current_health)
