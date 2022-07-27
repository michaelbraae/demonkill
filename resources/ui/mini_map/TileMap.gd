extends TileMap

func _ready() -> void:
	if is_instance_valid(GameState.tilemap):
		var cells = GameState.tilemap.get_used_cells_by_id(0)
		var floor_cells = GameState.tilemap.get_used_cells_by_id(1)
		if cells.size() and floor_cells.size():
			buildMiniMap(cells, 0)
			buildMiniMap(floor_cells, 1)
		else:
			visible = false
	else:
		visible = false

func buildMiniMap(cells, cell_id) -> void:
	for cell in cells:
		set_cell(cell.x, cell.y, cell_id)
