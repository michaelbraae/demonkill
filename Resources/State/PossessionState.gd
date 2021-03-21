extends Node

var possessedNPC
const PLAYER_SCENE = preload('res://Resources/Actors/Player/Player.tscn')
onready var GameState = get_node('/root/GameState')
onready var FeedbackHandler = get_node('/root/FeedbackHandler')

func handlePossessionDeath(spawn_position) -> void:
	FeedbackHandler.warp()
	possessedNPC.queue_free()
	GameState.state = GameState.CONTROLLING_PLAYER
	var current_scene = get_tree().get_current_scene()
	var player_instance = PLAYER_SCENE.instance()
	current_scene.add_child(player_instance)
	player_instance.position = spawn_position
	player_instance.camera2D.make_current()

func possessNewEntity(possession_range, current_possession) -> void:
	var areas = possession_range.get_overlapping_areas()
	if areas:
		for area in areas:
			if area.get_name() == 'EnemyBiteBox':
				var parent = area.get_parent()
				if parent.state == parent.STUNNED:
					FeedbackHandler.warp()
					GameState.state = GameState.CONTROLLING_NPC
					parent.npc_camera.make_current()
					parent.bite_button.hide()
					parent.health = parent.MAX_HEALTH
					parent.attack_started = false
					parent.attack_landed = false
					PossessionState.possessedNPC = parent
					current_possession.queue_free()
					break
