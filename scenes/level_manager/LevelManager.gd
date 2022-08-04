extends Node

var current_scene = null
const PLAYER_SCENE = preload('res://scenes/character/player/Player.tscn')

# warning-ignore-all:return_value_discarded

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_scene(path):
	call_deferred('_deferred_goto_scene', path)

onready var thread: Thread = Thread.new()

func _deferred_goto_scene(path : String) -> void:
	# reset any slomo effects :D
	Engine.time_scale = 1
	UIManager.get_node("LoadingScreen").visible = true
	# It is now safe to remove the current scene
	current_scene.free()
	thread.start(self, "prepare_scene", ResourceLoader.load_interactive(path))

func prepare_scene(interactive_ldr):
	while true:
		var err = interactive_ldr.poll()
		if err == ERR_FILE_EOF:
			print("load complete...")
			UIManager.get_node("LoadingScreen").visible = false
			call_deferred("load_complete")
			return interactive_ldr.get_resource()

func load_complete() -> void:
	var level_res = thread.wait_to_finish()
	current_scene = level_res.instance();
	
	get_tree().get_root().add_child(current_scene)
	
	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
	
	var spawnPoint = current_scene.find_node('SpawnPoint')
	
	if is_instance_valid(GameState.player):
		GameState.player.queue_free()
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
