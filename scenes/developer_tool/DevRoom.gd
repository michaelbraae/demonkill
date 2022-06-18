extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var totalSpawns = 1
	for i in range(GameState.developer_tool_state.size()):
		for _j in range(GameState.developer_tool_state[i]["count"]):
			var scene_resource = ResourceLoader.load(GameState.developer_tool_state[i]["scene"])

			# Instance the new scene.
			var current_scene = scene_resource.instance()
			$YSort.add_child(current_scene)
			
			# set it's position to be equal to the spawn points
			current_scene.position = $NPCSpawnPoints.get_node("SpawnPoint" + str(totalSpawns)).position
			totalSpawns += 1
