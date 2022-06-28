extends CharacterBase

class_name BaseAI

onready var camera2D = $Camera2D

func isPossessed() -> bool:
	return GameState.state == GameState.CONTROLLING_NPC and PossessionState.possessedNPC == self

func nodeIsPossessed(node_arg : KinematicBody2D) -> bool:
	return GameState.state == GameState.CONTROLLING_NPC and PossessionState.current_possession == node_arg

# ENEMY SPECIFIC STATES:
enum {
	NAVIGATING,
	WANDERING,
	DASH,
	FOLLOWING_PLAYER,
	PRE_ATTACK,
	ATTACKING,
	POST_ATTACK,
	WITH_AXE,
	KNOCKED_BACK,
	TAKING_DAMAGE,
	STUNNED,
	PRE_DEATH,
	DEAD,
	POSSESSED,
	POSSESSION_TARGETING,
	POSSESSION_RECOVERY,
}

func getStateString() -> String:
	var state_string = 'NO STATE'
	match state:
		IDLE:
			state_string = 'IDLE'
		WANDERING:
			state_string = 'WANDERING'
		NAVIGATING:
			state_string = 'NAVIGATING'
		DASH:
			state_string = 'DASH'
		FOLLOWING_PLAYER:
			state_string = 'FOLLOWING_PLAYER'
		PRE_ATTACK:
			state_string = 'PRE_ATTACK'
		ATTACKING:
			state_string = 'ATTACKING'
		POST_ATTACK:
			state_string = 'POST_ATTACK'
		WITH_AXE:
			state_string = 'WITH_AXE'
		TAKING_DAMAGE:
			state_string = 'TAKING_DAMAGE'
		STUNNED:
			state_string = 'STUNNED'
		PRE_DEATH:
			state_string = 'PRE_DEATH'
		DEAD:
			state_string = 'DEAD'
		POSSESSED:
			state_string = 'POSSESSED'
		POSSESSION_TARGETING:
			state_string = 'POSSESSION_TARGETING'
		POSSESSION_RECOVERY:
			state_string = 'POSSESSION_RECOVERY'
	return state_string

func _ready():
	initialiseConfig()
	animatedSprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")

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
