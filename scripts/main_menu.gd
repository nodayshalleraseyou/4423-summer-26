extends Control
class_name MainMenu




func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://core-scenes/main_scene.tscn")
	print("play!")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
	print("quit")
