extends Resource
class_name Utils

static func in_range(cell_a, cell_b : Vector2i, max_range : float) -> bool:
	return cell_a.distance_squared_to(cell_b) <= max_range*max_range
