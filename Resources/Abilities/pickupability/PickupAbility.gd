extends Node

class_name PickupAbility

func _ready() -> void:
	$Area2D.connect('area_entered', self, 'on_area_entered')

func on_area_entered(body) -> void:
	if body.get_parent() == GameState.player:
		print('pickup attempt')
		queue_free()
