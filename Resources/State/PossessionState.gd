extends Node

var possessedNPC
const PLAYER_SCENE = preload("res://Resources/Actors/Player/Player.tscn")
onready var GameState = get_node("/root/GameState")

func handlePossessionDeath(spawn_position) -> void:
	possessedNPC.queue_free()
	GameState.state = GameState.CONTROLLING_PLAYER
	var current_scene = get_tree().get_current_scene()
	var player_instance = PLAYER_SCENE.instance()
	current_scene.add_child(player_instance)
	player_instance.position = spawn_position
	player_instance.camera2D.make_current()
