extends Node

const PLAYER_SCENE = preload('res://resources/actors/player/Player.tscn')

var bite_box

var current_possession

var possessedNPC

func getCurrentPossession():
	if GameState.CONTROLLING_NPC and current_possession:
		return current_possession
	return GameState.player

func handlePossessionDeath(spawn_position) -> void:
	FeedbackHandler.warp()
	current_possession.queue_free()
	
	# intantiate the player scene and add to scene
	GameState.state = GameState.CONTROLLING_PLAYER
	var current_scene = get_tree().get_current_scene()
	var player_instance = PLAYER_SCENE.instance()
	GameState.player = player_instance
	current_scene.add_child(player_instance)
	
	# assign the player as the current_actor
	InputHandler.current_actor = player_instance
	FeedbackHandler.current_camera = player_instance.camera2D
	
	# set the player's location
	player_instance.position = spawn_position
	bite_box = player_instance.possession_hitbox
	player_instance.camera2D.make_current()

func exitPossession(spawn_position) -> void:
	# intantiate the player scene and add to scene
	GameState.state = GameState.CONTROLLING_PLAYER
	var current_scene = get_tree().get_current_scene()
	var player_instance = PLAYER_SCENE.instance()
	GameState.player = player_instance
	current_scene.add_child(player_instance)
	
	current_possession.handlePossessionExit()

	# handle the possession dash 
	player_instance.possession_dash_vector = player_instance.getAttackDirection()
	player_instance.initiateDash()
	player_instance.state = player_instance.POSSESSION_DASH
	player_instance.possession_targets_to_ignore = [current_possession]
	
	# assign the player as the current_actor
	InputHandler.current_actor = player_instance
	FeedbackHandler.current_camera = player_instance.camera2D
	
	# set the player's location
	player_instance.position = spawn_position
	bite_box = player_instance.possession_hitbox
	player_instance.camera2D.make_current()

func possessEntity(new_possession) -> void:
	current_possession = new_possession
	possessedNPC = new_possession
	GameState.state = GameState.CONTROLLING_NPC
	new_possession.camera2D.make_current()
	new_possession.health = new_possession.max_health
	new_possession.attack_started = false
	new_possession.attack_landed = false
	new_possession.target_actor = null
	InputHandler.current_actor = new_possession
	FeedbackHandler.current_camera = new_possession.camera2D
	GameState.player.queue_free()
	new_possession.state = new_possession.STUNNED
	new_possession.onPossess()
