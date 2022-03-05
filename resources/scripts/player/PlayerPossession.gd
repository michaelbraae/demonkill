extends PlayerAction

class_name PlayerPossession

func _process(_delta):
	if Input.is_action_just_pressed("possess"):
		PossessionState.possessNewEntity()
