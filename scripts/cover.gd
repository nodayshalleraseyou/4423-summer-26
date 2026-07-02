extends Area2D

const allow_distance : float = 25
#these are the positions from which projectiles can pass through
var cover_coords : Array[Vector2i]  

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(check_projectile_hit)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass # Replace with function body.
	

func check_projectile_hit(area : Area2D):
	if area is not Projectile:
		return
	var projectile : Projectile = area as Projectile
	if projectile.start_pos.distance_squared_to(global_position) > allow_distance*allow_distance:	
		area.queue_free()
