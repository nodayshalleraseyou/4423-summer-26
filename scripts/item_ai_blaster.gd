extends ItemAI
class_name ItemAIBlaster

@onready var blaster : Blaster = get_parent()

const can_see_bid : float = 0.2
const in_range_bid : float = 0.2

const ammo_ratio_bid : float = 0.1
const mag_ratio_bid : float = 0.1 

const range_match_bid : float = 0.2 #are we the perfect distance to fire?


var path_end_pos : Vector2i

func make_bid(ai : AI, creature : Creature, game_manager : GameManager) -> float:
	
	var bid : float = 0
	if blaster.current_ammo == 0 and blaster.current_mags == 0:
		return 0 #no ammo!
	
	if !is_instance_valid(target_creature):
		target_creature = game_manager.find_nearest_target(creature) 
	if !is_instance_valid(target_creature):
		return 0
		
	var in_range : bool = Utils.in_range(creature.current_pos, target_creature.current_pos, blaster.get_projectile_range())
	var can_see : bool = game_manager.can_see(creature.current_pos,target_creature.current_pos)
	
	if in_range:
		bid += in_range_bid
	if can_see:
		bid += can_see_bid
	
	var distance : float = creature.current_pos.distance_to(target_creature.current_pos)
	var final_range_match_bid : float = range_match_bid / abs(distance - blaster.get_projectile_range()) + 1
	
	bid += final_range_match_bid
	return bid

func take_action(ai : AI, creature : Creature, game_manager : GameManager) -> bool:
	if creature.current_item != blaster:
		creature.set_current_item_direct(blaster)
		path = []
		return true
	
	if blaster.current_ammo == 0 and blaster.current_mags == 0:
		return false
	if blaster.current_ammo == 0:
		creature.reload_blaster()
		return false 
	
	if !is_instance_valid(target_creature):
		target_creature = game_manager.find_nearest_target(creature) 
	
	if !is_instance_valid(target_creature):
		return false #no target, go back
	
	var in_range : bool = Utils.in_range(creature.current_pos, target_creature.current_pos, blaster.get_projectile_range())
	var can_see : bool = game_manager.can_see(creature.current_pos,target_creature.current_pos)
	
	if in_range and can_see:
		creature.use_current_item()
		return false
	

	
	if path.size() == 0\
	|| !Utils.in_range(path_end_pos, target_creature.current_pos, blaster.get_projectile_range())\
	|| !game_manager.can_see(path_end_pos,target_creature.current_pos):
		path_end_pos = ai.find_attack_pos(creature.current_pos,target_creature.current_pos,blaster.get_projectile_range())
		path = ai.pathfind(creature.current_pos,path_end_pos)
		
	#ensure our destination is still valid
	if path.size() > 0:
		if creature.move_to(path[0]):
			path.remove_at(0)
			return false
		else:
			path.clear()
			return false
	
	return false
	
	
	
	
