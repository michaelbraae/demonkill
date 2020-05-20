extends KinematicBody2D

class_name BaseAI

var state
onready var animatedSprite = $AnimatedSprite

# STATES:
enum {
	IDLE,
	WANDERING,
	NAVIGATING,
	DASHING,
	FOLLOWING_PLAYER,
	PRE_ATTACK,
	ATTACKING,
	POST_ATTACK,
	TAKING_DAMAGE,
	STUNNED,
	PRE_DEATH,
	DEAD,
}

func setState(newState : int) -> void:
	state = newState

func getState() -> int:
	return state

func getStateString() -> String:
	var state_string = "NO STATE"
	match state:
		IDLE:
			state_string = "IDLE"
		WANDERING:
			state_string = "WANDERING"
		NAVIGATING:
			state_string = "NAVIGATING"
		DASHING:
			state_string = "DASHING"
		FOLLOWING_PLAYER:
			state_string = "FOLLOWING_PLAYER"
		PRE_ATTACK:
			state_string = "PRE_ATTACK"
		ATTACKING:
			state_string = "ATTACKING"
		POST_ATTACK:
			state_string = "POST_ATTACK"
		TAKING_DAMAGE:
			state_string = "TAKING_DAMAGE"
		STUNNED:
			state_string = "STUNNED"
		PRE_DEATH:
			state_string = "PRE_DEATH"
		DEAD:
			state_string = "DEAD"
	return state_string

func _ready():
	initialiseConfig()

func initialiseConfig():
	pass

func _on_AnimatedSprite_animation_finished() -> void:
	handlePostAnimState()

func handlePostAnimState() -> void:
	pass
