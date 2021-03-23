extends PlayerAttack

class_name PlayerPossession

func _process(_delta):
	if Input.is_action_just_pressed('bite'):
		PossessionState.initiateBite(self)
