extends Node

class_name UIManager

# list all the unique windows - THESE CANNOT BE ACTIVE AT THE SAME TIME
enum {
	PAUSE_SCREEN,
	MAIN_MENU,
	PLAYER_UI,
}

func _ready() -> void:
	InputEmitter.connect("ui_cancel", self, "ui_cancel")

func ui_cancel() -> void:
	if get_tree().paused:
		$PauseMenu.resume()
	else:
		$PauseMenu.pause()

func transitionBetweenUI(new_ui_state) -> void:
	$PlayerUI.visible = false
	$PauseMenu.visible = false
	

var state: int = PLAYER_UI setget set_state

func set_state(new_state) -> void:
	state = new_state




