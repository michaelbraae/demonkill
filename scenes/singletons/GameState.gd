extends Node

var state = MAIN_MENU

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

func _ready() -> void:
	if OS.is_debug_build():
		OS.window_fullscreen = false
	else:
		OS.window_fullscreen = true

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

func _process(_delta) -> void:
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
