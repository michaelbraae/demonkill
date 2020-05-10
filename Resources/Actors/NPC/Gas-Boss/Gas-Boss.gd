extends "res://Resources/Scripts/NPC/PathfindingAI.gd"

onready var animatedSprite = $AnimatedSprite

func getAnimation() -> String:
	if velocity.x >= 0.1:
		animatedSprite.flip_h = false
		return "run"
	if velocity.x <= -0.1:
		animatedSprite.flip_h = true
		return "run"
	if velocity.y != 0:
		return "run"
	return "idle"

func _physics_process(delta : float) -> void:
	._physics_process(delta)
	animatedSprite.play(getAnimation())
	
