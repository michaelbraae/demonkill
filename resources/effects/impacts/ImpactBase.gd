extends Node2D

class_name ImpactBase

onready var animatedSprite = $AnimatedSprite

func play() -> void:
	animatedSprite.play()

func _on_AnimatedSprite_animation_finished():
	queue_free()
