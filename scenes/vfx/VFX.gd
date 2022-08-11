extends AnimatedSprite



func _ready() -> void:
	# warning-ignore:return_value_discarded
	connect("animation_finished", self, "animation_finished")

func animation_finished() -> void:
	queue_free()
