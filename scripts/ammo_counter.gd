extends Label
class_name AmmoCounter


func set_ammo_count(current_ammo : int, max_ammo : int):
	text = str(current_ammo) + " / " + str(max_ammo)
	if current_ammo == 1:
		modulate = Color(1.0,1,0,1)
	if current_ammo == 0:
		modulate = Color(1.0,0,0,1)
