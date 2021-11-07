extends Area2D

const COMBAT_TEST_ROOM = 'res://Scenes/Levels/room-1.tscn'

func _process(_delta : float) -> void:
	var areas = get_overlapping_areas()
	if areas:
		for area in areas:
			if area.get_name() == 'HitBox' and area.get_parent() == GameState.player:
				LevelManager.goto_scene(COMBAT_TEST_ROOM)
