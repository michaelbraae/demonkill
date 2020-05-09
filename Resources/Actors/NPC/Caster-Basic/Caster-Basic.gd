extends "res://Resources/Scripts/NPC/PathfindingAI.gd"

# move towards the player.
# once within attack range and with LOS
# fire a projectile at the player

func playerInRange() -> bool:
	return true
	
func fireAtPlayer() -> void:
	pass

func _physics_process(delta : float) -> void:
	if playerInRange():
		fireAtPlayer()
#	else:
	._physics_process(delta)
