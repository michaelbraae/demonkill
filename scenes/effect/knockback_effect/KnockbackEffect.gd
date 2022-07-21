extends Effect

class_name KnockbackEffect

var hit_direction: float

export var speed: int

export var decay: int

func _ready() -> void:
	hit_direction = owner.target_vector.angle()
