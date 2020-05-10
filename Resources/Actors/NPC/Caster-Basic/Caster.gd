extends "res://Resources/Scripts/NPC/PathfindingAI.gd"

const ATTACK_RANGE = 200
# move towards the player.
# once within attack range and with LOS
# fire a projectile at the player

func playerInRange() -> bool:
	var distance_to_player = get_global_position().distance_to(
		player.get_global_position()
	)
	if distance_to_player <= ATTACK_RANGE:
		return true
	return false

func fireAtPlayer() -> void:
	pass

func _physics_process(delta : float) -> void:
	if player:
		if playerInRange():
			detectBlockers()
			if not path_blocked:
				fireAtPlayer()
		else:
			._physics_process(delta)
