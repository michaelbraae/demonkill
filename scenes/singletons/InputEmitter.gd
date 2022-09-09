extends Node

signal ui_accept
signal ui_cancel

# docs say use past tense to name signals :hmmm:
signal movement_ability
signal attack_slot_1
signal attack_slot_2
signal interacted
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
		emit_signal("attack_slot_1")

func action_2() -> void:
	if GameState.is_paused:
		pass
	else:
		emit_signal("attack_slot_2")

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

func action_4() -> void:
	emit_signal("interacted")

func ui_cancel() -> void:
	emit_signal("ui_cancel")
