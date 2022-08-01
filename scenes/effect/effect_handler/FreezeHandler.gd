extends DOTEffectHandler

func begin_effect(effect: DotEffect) -> void:
	if stacks < 1:
		stacks += 1
		effect_duration_timer.start(effect.effect_duration)
		get_parent().owner.freeze(effect.effect_duration)
		emit_signal(started_signal)
	# at this point we play the existing DOT logic
	# then we need to find a way to freeze the player
