extends TileMap

func set_up() -> void:
	if is_instance_valid(GameState.tilemap):
		var cells = GameState.tilemap.get_used_cells_by_id(0)
		var floor_cells = GameState.tilemap.get_used_cells_by_id(1)
		if cells.size() and floor_cells.size():
			clear()
			print("building minimap...")
			buildMiniMap(cells, 1)
			buildMiniMap(floor_cells, 0)
		else:
			visible = false
	else:
		visible = false

func buildMiniMap(cells, cell_id) -> void:
	for cell in cells:
		set_cell(cell.x, cell.y, cell_id)
