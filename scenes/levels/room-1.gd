extends Node2D

func _ready() -> void:
	buildAStarNavigation()
	connectAStarNavPoints()

var cell_coords = []

func buildAStarNavigation() -> void:
	var used_cells = $TileMap.get_used_cells_by_id(0)
	var count = 0
	for cell in used_cells:
		var new_cell_coord = {
			"id": count,
			"cell": cell
		}
		cell_coords.push_back(new_cell_coord)
		count += 1
		GameState.astar.add_point(new_cell_coord["id"], $TileMap.map_to_world(new_cell_coord["cell"]))

func findCellFromCoordinates(cell) -> Dictionary:
	for tile_cell in cell_coords:
		if cell == tile_cell["cell"]:
			return tile_cell
	return {}

func connectAStarNavPoints() -> void:
	var used_cells = $TileMap.get_used_cells_by_id(0)
	for cell in used_cells:
		# RIGHT, LEFT, DOWN, UP
		var neighbors = [Vector2(1,0), Vector2(-1,0), Vector2(0,1), Vector2(0,-1)]
		for neighbor in neighbors:
			var next_cell = cell + neighbor
			if used_cells.has(next_cell):
				GameState.astar.connect_points(
					findCellFromCoordinates(cell)["id"],
					findCellFromCoordinates(next_cell)["id"]
				)
