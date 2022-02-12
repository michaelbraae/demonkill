extends PickupAbility

class_name PickupFlameSwipe

const FLAME_SWIPE_SCENE = preload("res://resources/abilities/pickup_ability/flame_swipe/FlameSwipe.tscn")

func getPickupSpellConfig() -> Dictionary:
	return {
		"name": "Flame swipe",
		"type": "melee",
		"scene": FLAME_SWIPE_SCENE,
		"count": 1,
	}
