extends CharacterBase

class_name BaseAI

var state

onready var camera2D = $Camera2D

func isPossessed() -> bool:
	return GameState.state == GameState.CONTROLLING_NPC and PossessionState.possessedNPC == self

func nodeIsPossessed(node_arg : KinematicBody2D) -> bool:
	return GameState.state == GameState.CONTROLLING_NPC and PossessionState.current_possession == node_arg

# STATES:
enum {
	IDLE,
	NAVIGATING,
	DASH,
	DASH_RECOVERY,
	ATTACK_WARMUP,
	ATTACK_CONTACT,
	ATTACK_RECOVERY,
	AXE_INTERACTION,
	KNOCKED_BACK,
	STUNNED,
	PRE_DEATH,
	POSSESSION_TARGETING,
	POSSESSION_RECOVERY
}

func getStateString() -> String:
	var state_string = 'NO STATE'
	match state:
		IDLE:
			state_string = 'IDLE'
		NAVIGATING:
			state_string = 'NAVIGATING'
		DASH:
			state_string = 'DASH'
		ATTACK_WARMUP:
			state_string = 'ATTACK_WARMUP'
		ATTACK_CONTACT:
			state_string = 'ATTACK_CONTACT'
		ATTACK_RECOVERY:
			state_string = 'ATTACK_RECOVERY'
		AXE_INTERACTION:
			state_string = 'AXE_INTERACTION'
		STUNNED:
			state_string = 'STUNNED'
		PRE_DEATH:
			state_string = 'PRE_DEATH'
		POSSESSION_TARGETING:
			state_string = 'POSSESSION_TARGETING'
		POSSESSION_RECOVERY:
			state_string = 'POSSESSION_RECOVERY'
	return state_string

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
