extends Node
class_name AudioPool

var MASTER_VOLUME : float = 0.1

const POOL_SIZE = 12
var players: Array[AudioStreamPlayer] = []
var next_index := 0
var _last_played: Dictionary = {} 
var game_manager : GameManager
func _ready():
	game_manager = get_tree().current_scene.get_node("GameManager")
	for i in POOL_SIZE:
		var p = AudioStreamPlayer.new()
		p.bus = "SFX"
		add_child(p)
		players.append(p)
	
	
func play_begin_turn_sound(stream: AudioStream, pitch_min, pitch_max : float, volume : float = 1.0):
	var current_timer_value = game_manager.timer_value
	if _last_played.has(stream) and _last_played[stream] == current_timer_value:
		return
	_last_played[stream] = current_timer_value
	var p = players[next_index]
	next_index = (next_index + 1) % POOL_SIZE
	p.pitch_scale = randf_range(pitch_min, pitch_max)
	p.volume_db = linear_to_db(volume * MASTER_VOLUME)
	p.stream = stream
	p.play()
func clear_dict():
	_last_played = {}
