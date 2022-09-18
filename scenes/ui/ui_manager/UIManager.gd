extends Node

# list all the unique windows
enum {
	PAUSE_SCREEN,
	IN_GAME_UI,
}

# warning-ignore-all:return_value_discarded

func _ready() -> void:
	InputEmitter.connect("ui_cancel", self, "ui_cancel")

func clear_ui() -> void:
	for child in get_children():
		if child.has_method("disconnect_from_signals"):
			child.disconnect_from_signals()
		child.visible = false

func ui_cancel() -> void:
	# transitionBetweenUI(PAUSE_SCREEN)
	if get_tree().paused:
		$PauseMenu.resume()
		change_active_ui(IN_GAME_UI)
		# $PlayerUI.visible = true
	else:
		$PauseMenu.pause()
		change_active_ui(PAUSE_SCREEN)

func change_active_ui(new_ui_state: int) -> void:
	clear_ui()
	match new_ui_state:
		PAUSE_SCREEN:
			activate_ui_and_connect_to_signals($PauseMenu)
		IN_GAME_UI:
			activate_ui_and_connect_to_signals($PlayerUI)

func activate_ui_and_connect_to_signals(ui_node) -> void:
	ui_node.visible = true
	if ui_node.has_method("connect_to_signals"):
		ui_node.connect_to_signals()

func clear_icon_from_slot(slot: int) -> void:
	for child in get_children():
		if child.has_method("clear_icon_from_slot"):
			child.clear_icon_from_slot(slot)

var state: int = IN_GAME_UI setget set_state

func set_state(new_state) -> void:
	state = new_state

# when an enemy is destroyed a spirit may leave their body.
# the player can collect these spirits during a possession to increase the duration of their possession#

# THE NIGHTMARE! 
# a creature that can only be seen in the demon world?
