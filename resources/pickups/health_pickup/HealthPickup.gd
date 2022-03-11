extends Node2D

func _ready():
	$Area2D.connect("body_entered", self, "on_body_entered")

func on_body_entered(body) -> void:
	if body == GameState.player:
		PlayerState.health += 1
		queue_free()
