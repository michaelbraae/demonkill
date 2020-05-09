extends "res://Resources/Scripts/NPC/PathfindingAI.gd"

var attack_started = false
var attacked = false
var facing_direction = "down"
var interactable = false
var possessable = true 

onready var animatedSprite = $AnimatedSprite

func setInteractable(interactable_value : bool) -> void:
	interactable = interactable_value

func setPossessable(possessable_value : bool) -> void:
	possessable = possessable_value

func _on_AnimatedSprite_animation_finished() -> void:
	attack_started = false
	attacked = false

func getAnimation() -> String:
	if velocity.x >= 45:
		animatedSprite.flip_h = false
		facing_direction = "right"
		return "run"
	if velocity.x <= -45:
		animatedSprite.flip_h = true
		facing_direction = "right"
		return "run"
	if velocity.y != 0:
		return "run"
	return "idle"

func _physics_process(delta):
	._physics_process(delta)
	animatedSprite.play(getAnimation())
