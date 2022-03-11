extends PlayerAction

class_name PlayerPossession

func _process(_delta):
	if Input.is_action_pressed("possess"):
		state = POSSESSION_TARGETING
		Engine.time_scale = 0.3
	elif Input.is_action_just_released("possess"):
		state = POSSESSION_DASH
		Engine.time_scale = 1

func handlePlayerAction() -> void:
	if state == POSSESSION_TARGETING:
		animatedSprite.play(getAnimation())
	else:
		.handlePlayerAction()
