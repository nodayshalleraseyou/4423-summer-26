extends Node
class_name AI

var my_creature : Creature
var game_manager : GameManager
var target_creature : Creature

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	my_creature = get_parent()
	game_manager = get_tree().current_scene.get_node("GameManager")
	game_manager.register_ai(self)
	target_creature = game_manager.player_creature


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_ai():	
	pass

func find_attack_pos(current_pos, target_pos : Vector2i, range : int) -> Vector2i:
	#find a position to move to
	var valid_positions : Array[Vector2i] = []
	for x in range(-range, range+1):
		for y in range(-range, range+1):
			var new_pos : Vector2i = target_pos + Vector2i(x,y)
			if !game_manager.can_move_to(new_pos):
				continue
			if !game_manager.can_see(new_pos,target_pos):
				continue
			valid_positions.append(new_pos)
			pass
	if len(valid_positions) == 0:
		return current_pos
	return valid_positions[randi_range(0,valid_positions.size()-1)]

#returns a list of positions
# Returns a list of Vector2i positions from start to end (inclusive).
# Uses A* with Manhattan heuristic. Diagonal moves are not allowed.
func pathfind(start: Vector2i, end: Vector2i) -> Array[Vector2i]:
	if start == end:
		return []
	if !game_manager.can_move_to(end):
		return []
	
	if !game_manager.in_bounds(end):
		return []

	var open_set = {} #node -> f_score
	var came_from = {} #node -> previous node
	var g_score = {} #node -> cost from start
	var f_score = {} #node -> estimated total cost

	g_score[start] = 0
	var h_start = abs(start.x - end.x) + abs(start.y - end.y)
	f_score[start] = h_start
	open_set[start] = h_start

	var directions = [
		Vector2i(1, 0),
		Vector2i(-1, 0),
		Vector2i(0, 1),
		Vector2i(0, -1)
	]

	while not open_set.is_empty():
		#find node with lowest f_score in open_set
		var current: Vector2i
		var lowest_f = INF
		for node in open_set:
			if open_set[node] < lowest_f:
				lowest_f = open_set[node]
				current = node

		#if we reached the goal, reconstruct the path
		if current == end:
			var path: Array[Vector2i] = []
			var cur = end
			while cur in came_from:
				path.append(cur)
				cur = came_from[cur]
			#path.append(start)
			path.reverse()
			return path

		open_set.erase(current)


		for dir in directions:
			var neighbor = current + dir

			#make sure we can get thre!
			if neighbor != end and not game_manager.can_move_to(neighbor):
				continue
			if !game_manager.in_bounds(neighbor):
				continue

			var next_g = g_score[current] + 1
			if not g_score.has(neighbor) or next_g < g_score[neighbor]:
				came_from[neighbor] = current
				g_score[neighbor] = next_g
				var h_neighbor = abs(neighbor.x - end.x) + abs(neighbor.y - end.y)
				f_score[neighbor] = next_g + h_neighbor
				open_set[neighbor] = f_score[neighbor]

	return []
