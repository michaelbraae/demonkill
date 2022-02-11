extends PickupAbility

class_name PickupFireball

const FIREBALL_SCENE = preload("res://resources/abilities/pickup_ability/fireball/Fireball.tscn")

func getPickupSpellConfig() -> Dictionary:
	return {
		"name": "Fireball",
		"type": "ranged",
		"scene": FIREBALL_SCENE,
		"count": 1,
	}
