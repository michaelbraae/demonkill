extends Node

const PLAYER_SCENE = preload('res://scenes/character/player/Player.tscn')

var current_possession

var possessedNPC

func getCurrentPossession():
	if GameState.state == GameState.CONTROLLING_NPC and current_possession:
		return current_possession

func is_controlling_player() -> bool:
	if GameState.state == GameState.CONTROLLING_NPC and current_possession:
		return false
	return true

func is_player(character: KinematicBody2D) -> bool:
	return GameState.player == character

func get_player_controlled_character() -> Character:
	if GameState.state == GameState.CONTROLLING_PLAYER:
		return GameState.player
	if is_instance_valid(current_possession):
		return current_possession
	return GameState.player

func onPossessionExit() -> void:
	UIManager.get_node("Tsukuyomi").visible = false
	AudioManager.stop_audio(AudioManager.HEARTBEAT)
	# give the player back the axe if they possessed the enemy with axe
	# could be moved to an "possessed" signal that emits when the player or an NPC is possessed
	GameState.player.has_axe = !is_instance_valid(GameState.npc_with_axe)
	if is_instance_valid(GameState.npc_with_axe) && current_possession == GameState.npc_with_axe:
		GameState.player.has_axe = true
		GameState.npc_with_axe = null

func handlePossessionDeath(spawn_position) -> void:
	FeedbackHandler.warp()
	
	# intantiate the player scene and add to scene
	GameState.state = GameState.CONTROLLING_PLAYER
	var current_scene = get_tree().get_current_scene()
	var player_instance = PLAYER_SCENE.instance()
	GameState.player = player_instance
	current_scene.call_deferred("add_child", player_instance)
	
	current_possession.queue_free()
	disconnectFromInputSignals(current_possession)
	
	# assign the player as the current_actor
	InputHandler.current_actor = player_instance
	FeedbackHandler.current_camera = player_instance.camera2D
	
	onPossessionExit()
	
	# set the player's location
	if is_instance_valid(player_instance):
		player_instance.position = spawn_position
		player_instance.camera2D.make_current()

func exitPossession(spawn_position) -> void:
	# intantiate the player scene and add to scene
	GameState.state = GameState.CONTROLLING_PLAYER
	var current_scene = get_tree().get_current_scene()
	var player_instance = PLAYER_SCENE.instance()
	GameState.player = player_instance
	current_scene.add_child(player_instance)
	PlayerState.health += 10
	
	current_possession.handlePossessionExit()
	current_possession.setEnemyCollision()
	
	# handle the possession dash
	player_instance.initiate_possession_dash()
	player_instance.state = player_instance.POSSESSION_DASH
	player_instance.possession_targets_to_ignore = [current_possession]
	
	onPossessionExit()
	disconnectFromInputSignals(current_possession)
	
	# assign the player as the current_actor
	InputHandler.current_actor = player_instance
	FeedbackHandler.current_camera = player_instance.camera2D
	
	# set the player's location
	player_instance.position = spawn_position
	player_instance.camera2D.make_current()

func possessEntity(new_possession) -> void:
	UIManager.get_node("Tsukuyomi").visible = true
	AudioManager.play_audio(AudioManager.HEARTBEAT)
	connectToInputSignals(new_possession)
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
	FeedbackHandler.shake_camera()
	var possession_duration = GameState.player.possession_duration
	GameState.player.queue_free()
	new_possession.setPossessionCollisions()
	new_possession.state = new_possession.STUNNED
	new_possession.onPossess(possession_duration)

# warning-ignore-all:return_value_discarded
func connectToInputSignals(signal_target) -> void:
	InputEmitter.connect("attack_slot_1", signal_target, "basic_attack")
#	InputEmitter.connect("attack_slot_2", signal_target, "use_ability")
	InputEmitter.connect("attack_slot_2", signal_target, "attack_slot_2")
	InputEmitter.connect("movement_ability", signal_target, "movement_ability")
	InputEmitter.connect("possession_cast_begun", signal_target, "possession_cast_begun")
	InputEmitter.connect("possession_cast_ended", signal_target, "possession_cast_ended")

func disconnectFromInputSignals(signal_target) -> void:
	InputEmitter.disconnect("attack_slot_1", signal_target, "basic_attack")
	InputEmitter.disconnect("attack_slot_2", signal_target, "attack_slot_2")
	InputEmitter.disconnect("movement_ability", signal_target, "movement_ability")
	InputEmitter.disconnect("possession_cast_begun", signal_target, "possession_cast_begun")
	InputEmitter.disconnect("possession_cast_ended", signal_target, "possession_cast_ended")
