extends Node

var state = MAIN_MENU

onready var healthGUI = load('res://Scenes/GUI/Health/Health.tscn').instance()

var npc_with_axe

var player

enum {
	MAIN_MENU,
	PAUSE_MENU,
	CONTROLLING_PLAYER,
	CONTROLLING_NPC,
}

func getStateString() -> String:
	match state:
		MAIN_MENU:
			return 'MAIN_MENU'
		PAUSE_MENU:
			return 'PAUSE_MENU'
		CONTROLLING_PLAYER:
			return 'CONTROLLING_PLAYER'
		CONTROLLING_NPC:
			return 'CONTROLLING_NPC'
	return 'NO_STATE'

func prepareHealthGUI() -> void:
	get_tree().get_root().call_deferred('add_child', healthGUI)
