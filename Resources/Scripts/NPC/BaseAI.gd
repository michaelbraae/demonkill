extends KinematicBody2D

class_name BaseAI

var state

const IS_ENEMY = true

onready var GameState = get_node('/root/GameState')
onready var PossessionState = get_node('/root/PossessionState')
onready var InputHandler = get_node('/root/InputHandler')

onready var animatedSprite = $AnimatedSprite
onready var camera2D = $Camera2D

func isPossessed() -> bool:
	return GameState.state == GameState.CONTROLLING_NPC and PossessionState.possessedNPC == self

func nodeIsPossessed(node_arg : KinematicBody2D) -> bool:
	return GameState.state == GameState.CONTROLLING_NPC and PossessionState.possessedNPC == node_arg

# STATES:
enum {
	IDLE,
	WANDERING,
	NAVIGATING,
	DASH,
	FOLLOWING_PLAYER,
	PRE_ATTACK,
	ATTACKING,
	POST_ATTACK,
	KNOCKED_BACK,
	TAKING_DAMAGE,
	STUNNED,
	PRE_DEATH,
	DEAD,
	POSSESSED,
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
		TAKING_DAMAGE:
			state_string = 'TAKING_DAMAGE'
		STUNNED:
			state_string = 'STUNNED'
		PRE_DEATH:
			state_string = 'PRE_DEATH'
		DEAD:
			state_string = 'DEAD'
	return state_string

func _ready():
	initialiseConfig()

func initialiseConfig():
	pass

func _on_AnimatedSprite_animation_finished() -> void:
	handlePostAnimState()

func handlePostAnimState() -> void:
	pass
