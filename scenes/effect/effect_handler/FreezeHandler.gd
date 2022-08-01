extends DOTEffectHandler

func begin_effect(effect: DotEffect) -> void:
	.begin_effect(effect)
	# at this point we play the existing DOT logic
	# then we need to find a way to freeze the player
