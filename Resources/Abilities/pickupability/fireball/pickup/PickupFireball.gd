extends PickupAbility

class_name PickupFireball

var FIREBALL_SCENE = preload("res://Resources/Abilities/pickupability/fireball/Fireball.tscn")

func getPickupSpellConfig() -> Dictionary:
	return {
		"name": "Flame Swipe",
		"scene": FIREBALL_SCENE,
		"count": 1,
	}
