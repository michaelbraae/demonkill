extends "res://Resources/Scripts/NPC/AttackerAI.gd"

onready var attackRange = $AttackRange

func isPlayerInRange() -> bool:
	var overlapping_areas = attackRange.get_overlapping_areas()
	if overlapping_areas:
		for area in overlapping_areas:
			if area.get_parent().get("IS_PLAYER"):
				return true
	return false
