extends Node

var state = MAIN_MENU

onready var PlayerUI = load('res://scenes/ui/player_ui/PlayerUI.tscn').instance()

var is_paused: bool = false

var axe_instance

var npc_with_axe

var player
var player_ui

var developer_tool_state: Array = []

var tilemap: TileMap
var astar: AStar2D = AStar2D.new()

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
	player_ui = PlayerUI
	get_tree().get_root().call_deferred('add_child', PlayerUI)

func _process(_delta) -> void:
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
