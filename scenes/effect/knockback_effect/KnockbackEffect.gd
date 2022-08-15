extends Effect

class_name KnockbackEffect

var hit_direction: float

export var speed: int = 150

export var decay: int = 10

func _ready() -> void:
	hit_direction = owner.target_vector.angle()
