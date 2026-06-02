extends Area2D
class_name Projectile

@export var damage : int = 1

var speed : float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(check_hit)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += Vector2(0,-speed) * delta


func check_hit(area : Area2D):
	print("hit!")
	if area is Creature:
		area.take_damage(damage)
