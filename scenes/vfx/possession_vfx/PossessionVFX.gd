extends AnimatedSprite

func _ready() -> void:
	connect("animation_finished", self, "animation_finished")

func animation_finished() -> void:
	queue_free()
