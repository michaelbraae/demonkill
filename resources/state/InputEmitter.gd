extends Node

signal ui_accept
signal basic_attack
signal movement_ability

func ui_accept() -> void:
	if GameState.is_paused:
		emit_signal("ui_accept")
	else:
		emit_signal("movement_ability")

func action_1() -> void:
	if GameState.is_paused:
		pass
	else:
		emit_signal("basic_attack")
