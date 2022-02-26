extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for npcButton in $NPCButtons.get_children():
		npcButton.get_node("TextureButton").connect("button_down", self, "npc_button_down", [npcButton.get_name()])

func npc_button_down(npcName: String) -> void:
	print(npcName)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
