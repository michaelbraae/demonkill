extends Control

onready var tilemap = $TileMap

enum {
	WALL_CELL,
	FLOOR_CELL
}

func set_up() -> void:
	if is_instance_valid(GameState.tilemap):
		var cells = GameState.tilemap.get_used_cells_by_id(0)
		var floor_cells = GameState.tilemap.get_used_cells_by_id(1)
		if cells.size() and floor_cells.size():
			add_cells(cells, 0)
			add_cells(floor_cells, 1)
		else:
			visible = false
	else:
		visible = false

func add_cells(cells, cell_id) -> void:
	for cell in cells:
		tilemap.set_cell(cell.x, cell.y, cell_id)
