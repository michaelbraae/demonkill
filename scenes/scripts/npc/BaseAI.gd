extends CharacterBase

class_name BaseAI

onready var camera2D = $Camera2D

func isPossessed() -> bool:
	return GameState.state == GameState.CONTROLLING_NPC and PossessionState.possessedNPC == self

func nodeIsPossessed(node_arg : KinematicBody2D) -> bool:
	return GameState.state == GameState.CONTROLLING_NPC and PossessionState.current_possession == node_arg

func _ready():
	initialiseConfig()

func initialiseConfig() -> void:
	pass

func _on_AnimatedSprite_animation_finished() -> void:
	handlePostAnimState()

func handlePostAnimState() -> void:
	pass

func setPossessionCollisions() -> void:
	set_collision_layer_bit(1, true)
	set_collision_layer_bit(2, false)
	$HitBox.set_collision_layer_bit(1, true)
	$HitBox.set_collision_layer_bit(2, false)

func setEnemyCollision() -> void:
	set_collision_layer_bit(1, false)
	set_collision_layer_bit(2, true)
	$HitBox.set_collision_layer_bit(1, false)
	$HitBox.set_collision_layer_bit(2, true)
