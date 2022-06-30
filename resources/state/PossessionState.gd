extends Node

const PLAYER_SCENE = preload('res://resources/actors/player/Player.tscn')

var bite_box

var current_possession

var possessedNPC

var possession_duration = 5.0

func getCurrentPossession():
	if GameState.state == GameState.CONTROLLING_NPC and current_possession:
		return current_possession
	return GameState.player

func onPossessionExit() -> void:
	GameState.player.has_axe = !is_instance_valid(GameState.npc_with_axe)
	if is_instance_valid(GameState.npc_with_axe) && current_possession == GameState.npc_with_axe:
		GameState.player.has_axe = true
		GameState.npc_with_axe = null

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
	
	onPossessionExit()
	
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
	current_possession.setEnemyCollision()
	current_possession.resetAbilityCooldown()
	
	# handle the possession dash 
	player_instance.possession_dash_vector = player_instance.getAttackDirection()
	player_instance.initiateDash()
	player_instance.state = player_instance.POSSESSION_DASH
	player_instance.possession_targets_to_ignore = [current_possession]
	onPossessionExit()
	
	# assign the player as the current_actor
	InputHandler.current_actor = player_instance
	FeedbackHandler.current_camera = player_instance.camera2D
	
	# set the player's location
	player_instance.position = spawn_position
	bite_box = player_instance.possession_hitbox
	player_instance.camera2D.make_current()

func possessEntity(new_possession) -> void:
	rebindInputSignals(current_possession, new_possession)
	current_possession = new_possession
	possessedNPC = new_possession
	GameState.state = GameState.CONTROLLING_NPC
	new_possession.camera2D.make_current()
	new_possession.attack_started = false
	new_possession.attack_landed = false
	new_possession.target_actor = null
	if GameState.npc_with_axe == new_possession:
		GameState.npc_with_axe = null
		GameState.player.has_axe = true
	InputHandler.current_actor = new_possession
	FeedbackHandler.current_camera = new_possession.camera2D
	GameState.player.queue_free()
	new_possession.setPossessionCollisions()
	new_possession.resetAbilityCooldown()
	new_possession.state = new_possession.STUNNED
	new_possession.onPossess(possession_duration)

func rebindInputSignals(prev_possession, new_possession) -> void:
	connectToInputSignals(new_possession)
	disconnectFromInputSignals(prev_possession)

func connectToInputSignals(signal_target) -> void:
	InputEmitter.connect("basic_attack", signal_target, "basic_attack")
	InputEmitter.connect("movement_ability", signal_target, "movement_ability")
	InputEmitter.connect("use_ability", signal_target, "use_ability")

func disconnectFromInputSignals(signal_target) -> void:
	InputEmitter.disconnect("basic_attack", signal_target, "basic_attack")
	InputEmitter.disconnect("movement_ability", signal_target, "movement_ability")
	InputEmitter.disconnect("use_ability", signal_target, "use_ability")
