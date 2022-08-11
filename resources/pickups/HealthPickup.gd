extends Node2D

export var health_amount: int = 1

func _physics_process(_delta):
	var overlapping_areas = $Area2D.get_overlapping_areas()
	if overlapping_areas:
		for area in overlapping_areas:
			if area.get_name() == "HitBox":
				if (
					area.get_parent() == PossessionState.getCurrentPossession()
					&& PossessionState.getCurrentPossession() != GameState.player
				):
					PossessionState.getCurrentPossession().addHealth(health_amount)
				if area.get_parent() == GameState.player and PlayerState.health < PlayerState.max_health:
					PlayerState.addHealth(health_amount)
					queue_free()
