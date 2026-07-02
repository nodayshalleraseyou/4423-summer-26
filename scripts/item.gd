extends Node2D
class_name Item

var damage_mult : float = 1
var healing_mult : float = 1
var speed_mult : float = 1
var area_mult : float = 1

var damage_add : int = 0
var healing_add : int = 0
var speed_add : int = 0
var area_add : int = 0

@onready var item_ai : ItemAI = $ItemAI

func use(owner_creature : Creature):
	pass	

func reload():
	pass

func equip(creature : Creature):
	self.visible = true
	on_equip(creature)
	
func dequip(creature : Creature):
	self.visible = false
	on_dequip(creature)

func on_move(creature : Creature):
	pass

func on_take_damage(creature : Creature):
	pass

func on_equip(creature : Creature):
	pass
	
func on_dequip(creature : Creature):
	pass
