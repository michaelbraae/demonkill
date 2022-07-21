extends AnimatedSprite

# warning-ignore-all:return_value_discarded

func _ready() -> void:
	connect("animation_finished", self, "animation_finished")

func animation_finished() -> void:
	queue_free()
