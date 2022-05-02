extends Node2D

const health_amount = 1

func _physics_process(_delta):
	var overlapping_areas = $Area2D.get_overlapping_areas()
	if overlapping_areas:
		for area in overlapping_areas:
			print(area.get_name())
			if area.get_name() == "HitBox":
				if (
					area.get_parent() == PossessionState.getCurrentPossession()
					&& PossessionState.getCurrentPossession() != GameState.player
				):
					PossessionState.getCurrentPossession().addHealth(health_amount)
				if area.get_parent() == GameState.player:
					PlayerState.addHealth(health_amount)
				queue_free()
