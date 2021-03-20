extends Node

var state = MAIN_MENU

onready var healthGUI = load("res://Scenes/GUI/Health/Health.tscn").instance()

enum {
	MAIN_MENU,
	PAUSE_MENU,
	CONTROLLING_PLAYER,
	CONTROLLING_NPC,
}

func prepareHealthGUI() -> void:
	get_tree().get_root().call_deferred("add_child", healthGUI)
