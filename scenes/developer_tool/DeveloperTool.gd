extends Control

const NPCS = []
var totalNPCCount = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$PlayButton.connect("button_down", self, "play_button_down")
	for npcButton in $NPCButtons.get_children():
		npcButton.get_node("TextureButton").connect("button_down", self, "npc_button_down", [npcButton.getSceneString()])

func play_button_down() -> void:
	GameState.developer_tool_state = NPCS
	LevelManager.goto_scene("res://scenes/developer_tool/DevRoom.tscn")

func npc_button_down(npcSceneString: String) -> void:
	var npcInSlot = false
	if totalNPCCount < 30:
		for npc in NPCS:
			if npc["scene"] == npcSceneString:
				npc["count"] += 1
				npcInSlot = true
		if !npcInSlot:
			NPCS.push_back({
				"scene": npcSceneString,
				"count": 1
			})
		totalNPCCount += 1
		print(NPCS)
