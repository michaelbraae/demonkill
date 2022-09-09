extends Node

var ability_cool_down_timer
var ABILITY_COOL_DOWN = 2.0

func fireProjectile(global_position : Vector2, attack_direction : Vector2) -> void:
	if ability_cool_down_timer.is_stopped():
		ability_cool_down_timer.start(ABILITY_COOL_DOWN)
