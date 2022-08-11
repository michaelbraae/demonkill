extends Node

# list all the unique windows
enum {
	PAUSE_SCREEN,
	MAIN_MENU,
	PLAYER_UI,
}

# warning-ignore-all:return_value_discarded

func _ready() -> void:
	InputEmitter.connect("ui_cancel", self, "ui_cancel")

func ui_cancel() -> void:
	transitionBetweenUI(PAUSE_SCREEN)
	if get_tree().paused:
		$PauseMenu.resume()
		$PlayerUI.visible = true
	else:
		$PauseMenu.pause()

func transitionBetweenUI(new_ui_state: int) -> void:
	print(new_ui_state)
	$PlayerUI.visible = false
	$PauseMenu.visible = false

var state: int = PLAYER_UI setget set_state

func set_state(new_state) -> void:
	state = new_state

# when an enemy is destroyed a spirit may leave their body.
# the player can collect these spirits during a possession to increase the duration of their possession#

# THE NIGHTMARE! 
# a creature that can only be seen in the demon world?
