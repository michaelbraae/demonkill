extends Control

const NPCS = []
var totalNPCCount = 0

func _ready():
	$PlayButton.connect("button_down", self, "play_button_down")

func play_button_down() -> void:
	for npc_button in $NPCButtons.get_children():
		NPCS.push_back(npc_button.getSceneString())
#	NPCS.push_back($NPCButtons/FlameSwipeImpButton.getSceneString())
	GameState.developer_tool_state = NPCS
	LevelManager.goto_scene("res://scenes/developer_tool/DevRoom.tscn")
