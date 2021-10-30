extends PickupAbility

class_name PickupFireball

func getPickupSpellConfig() -> Dictionary:
	return {
		"name": "PickupFireball",
		"scene": "res://Resources/Abilities/pickupability/pickupfireball/PickupFireball.tscn",
		"count": 1,
	}
