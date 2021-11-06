extends PickupAbility

class_name PickupFlameSwipe

var FLAME_SWIPE_SCENE = preload("res://Resources/Abilities/pickupability/flameswipe/FlameSwipe.tscn")

func getPickupSpellConfig() -> Dictionary:
	return {
		"name": "Flame Swipe",
		"scene": FLAME_SWIPE_SCENE,
		"count": 1,
	}
