extends Node

var current_scene = null
const PLAYER_SCENE = preload("res://Resources/Actors/Player/Player.tscn")

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path : String):
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var scene_resource = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = scene_resource.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
	var player_instance = PLAYER_SCENE.instance()
	current_scene.add_child(player_instance)
	# the spawn point should be an argument but it could default to SpawnPoint
	var spawnPoint = current_scene.get_node("SpawnPoint")
	player_instance.position = spawnPoint.position
	
