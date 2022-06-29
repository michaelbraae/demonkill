extends Sprite

func _ready() -> void:
	# warning-ignore:return_value_discarded
	$Tween.connect("tween_all_completed", self, "on_tween_completed")
	$Tween.interpolate_property(
		self,
		"modulate:a",
		1.0,
		0.0,
		0.8,
		Tween.TRANS_QUART,
		Tween.EASE_OUT
	)
	$Tween.start()

func on_tween_completed() -> void:
	queue_free()
