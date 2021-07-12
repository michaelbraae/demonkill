extends PlayerPossession

class_name Player

func _process(_delta):
	if Input.is_action_pressed("light"):
		$Light2D.energy = 1.6
	else:
		$Light2D.energy = 1
