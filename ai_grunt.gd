extends AI
class_name AIGrunt



var controlling_item : ItemAI 
var keep_controlling_item : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()



func take_turn():
	
	if my_creature.inventory.size() == 0:
		return
	if !is_instance_valid(controlling_item):
		keep_controlling_item = false
	
	if !keep_controlling_item:
		var best_item : ItemAI 
		var best_bid : float = 0
		for i in range(0,my_creature.inventory.size()):
			var temp_bid : float = my_creature.inventory[i].item_ai.make_bid(self, my_creature, game_manager)
			print(temp_bid)
			if temp_bid > best_bid:
				best_item = my_creature.inventory[i].item_ai
				best_bid = temp_bid
		
		controlling_item = best_item
	
	if !is_instance_valid(controlling_item):
		return
	keep_controlling_item = controlling_item.take_action(self, my_creature, game_manager)




func update_ai():
	super.update_ai()

	if is_instance_valid(target_creature):
		my_creature.aim_current_item(target_creature.global_position)
