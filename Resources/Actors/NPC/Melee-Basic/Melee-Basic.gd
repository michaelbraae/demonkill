extends "res://Resources/Scripts/NPC/PathfindingAI.gd"

var attack_started = false
var attacked = false

func _on_AnimatedSprite_animation_finished() -> void:
	attack_started = false
	attacked = false
