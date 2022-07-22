extends Node

var current_scene = null
const PLAYER_SCENE = preload('res://scenes/character/player/Player.tscn')

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_scene(path):
	call_deferred('_deferred_goto_scene', path)

func _deferred_goto_scene(path : String):
	# reset any slomo effects :D
	Engine.time_scale = 1
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
#	var spawnPoint = get_tree().get_root().find_node("SpawnPoint")
	var spawnPoint = current_scene.find_node('SpawnPoint')
	
#	var player_ui = get_tree().get_root().get_node("root/PlayerUI")
	if is_instance_valid(spawnPoint):
		var player_controlled_actor
		if GameState.state == GameState.CONTROLLING_NPC:
			player_controlled_actor = PossessionState.possessedNPC
		else:
			player_controlled_actor = PLAYER_SCENE.instance()
			GameState.state = GameState.CONTROLLING_PLAYER
			GameState.player = player_controlled_actor
			PlayerState.health = PlayerState.max_health
			PlayerState.mana = PlayerState.max_mana
		current_scene.get_node('YSort').add_child(player_controlled_actor)
		# the spawn point should be an argument but it could default to SpawnPoint
		player_controlled_actor.position = spawnPoint.position
