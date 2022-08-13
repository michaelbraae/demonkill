extends Node2D

export var health_amount: int = 1

func _ready() -> void:
	$Area2D.connect("area_entered", self, "area_entered")

func area_entered(body) -> void:
	if body.get_name() == "HitBox":
		if (
			body.get_parent() == PossessionState.getCurrentPossession()
			&& PossessionState.getCurrentPossession() != GameState.player
		):
			PossessionState.getCurrentPossession().addHealth(health_amount)
		if body.get_parent() == GameState.player and PlayerState.health < PlayerState.max_health:
			PlayerState.addHealth(health_amount)
			queue_free()
