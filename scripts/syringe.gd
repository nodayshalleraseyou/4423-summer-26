extends UsesItem
class_name Syringe

@export_category("Syringe")
@export var amount_to_heal : int = 1

func use_uses_item(owner_creature : Creature):
	owner_creature.heal(amount_to_heal * healing_mult + healing_add)
