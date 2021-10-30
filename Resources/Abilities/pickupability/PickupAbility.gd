extends Node

class_name PickupAbility

func _ready() -> void:
	$Area2D.connect('area_entered', self, 'on_area_entered')

func getPickupSpellConfig() -> Dictionary:
	return {}

func on_area_entered(body) -> void:
	if body.get_name() == "HitBox" and body.get_parent() == GameState.player:
		GameState.player.pickupSpell(getPickupSpellConfig())
		queue_free()
