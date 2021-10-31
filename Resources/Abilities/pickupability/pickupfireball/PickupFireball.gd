extends PickupAbility

class_name PickupFireball

var FIREBALL_SCENE = preload("res://Resources/Abilities/fireball/Fireball.tscn")

func getPickupSpellConfig() -> Dictionary:
	return {
		"name": "PickupFireball",
		"scene": FIREBALL_SCENE,
		"count": 1,
	}
