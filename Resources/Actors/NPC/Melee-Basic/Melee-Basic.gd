extends "res://Resources/Scripts/NPC/PossessableAI.gd"

var attack_started = false
var attacked = false
var facing_direction = "down"

onready var animatedSprite = $AnimatedSprite

func _on_AnimatedSprite_animation_finished() -> void:
	attack_started = false
	attacked = false

func getAnimation() -> String:
	if velocity.x >= 0.1:
		animatedSprite.flip_h = false
		facing_direction = "right"
		return "run"
	if velocity.x <= -0.1:
		animatedSprite.flip_h = true
		facing_direction = "right"
		return "run"
	if velocity.y != 0:
		return "run"
	return "idle"

func _physics_process(delta : float) -> void:
	._physics_process(delta)
	animatedSprite.play(getAnimation())
