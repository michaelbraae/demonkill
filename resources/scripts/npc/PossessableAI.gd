extends CombatReadyAI

class_name PossessableAI

func _process(_delta):
	if isPossessed() and Input.is_action_just_pressed("possess"):
		PossessionState.handlePossessionDeath(position)
