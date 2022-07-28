extends Node

signal ui_accept
signal ui_cancel

# docs say use past tense to name signals :hmmm:
signal movement_ability
signal basic_attack
signal use_ability
signal possession_cast_begun
signal possession_cast_ended

func _ready() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS

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

func action_2() -> void:
	if GameState.is_paused:
		pass
	else:
		emit_signal("use_ability")

func action_3_pressed() -> void:
	if GameState.is_paused:
		pass
	else:
		emit_signal("possession_cast_begun")

func action_3_released() -> void:
	if GameState.is_paused:
		pass
	else:
		emit_signal("possession_cast_ended")

func ui_cancel() -> void:
	emit_signal("ui_cancel")
