extends Node2D

var amplitude := 3.0

var frequency := 5.0

onready var icon = $AnimatedSprite

var time: float = 0.0

onready var default_pos = icon.get_position()

export(PackedScene) var weapon

# warning-ignore-all:return_value_discarded

func _process(delta: float) -> void:
	time += delta * frequency
	icon.set_position(default_pos + Vector2(0, sin(time) * amplitude))
	if get_global_position().distance_to(GameState.player.position) < 30:
		$WeaponCard.visible = true
	else:
		$WeaponCard.visible = false
