extends PickupAbility

class_name PickupFireball

const FIREBALL_SCENE = preload("res://Resources/Abilities/pickupability/fireball/Fireball.tscn")

func getPickupSpellConfig() -> Dictionary:
	return {
		"name": "Fireball",
		"scene": FIREBALL_SCENE,
		"count": 1,
	}
