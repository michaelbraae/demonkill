extends Area2D

const COMBAT_TEST_ROOM = "res://Scenes/Levels/dojo-1.tscn"

func _process(_delta : float) -> void:
	var areas = get_overlapping_areas()
	if areas:
		for area in areas:
			if area.get_parent().get("IS_PLAYER"):
				LevelManager.goto_scene(COMBAT_TEST_ROOM)
