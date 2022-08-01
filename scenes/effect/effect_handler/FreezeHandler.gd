extends DOTEffectHandler

func begin_effect(effect: DotEffect) -> void:
	print(effect)
	emit_signal(started_signal)
