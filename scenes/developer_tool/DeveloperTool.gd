extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


const NPCS = [];
# Called when the node enters the scene tree for the first time.
func _ready():
	for npcButton in $NPCButtons.get_children():
		npcButton.get_node("TextureButton").connect("button_down", self, "npc_button_down", [npcButton.getSceneString()])

func npc_button_down(npcSceneString: String) -> void:
	var npcInSlot = false
	for npc in NPCS:
		if npc["scene"] == npcSceneString:
			npc["count"] += 1
			npcInSlot = true
	if !npcInSlot:
		NPCS.push_back({
			"scene": npcSceneString,
			"count": 1
		})
	print(NPCS)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
