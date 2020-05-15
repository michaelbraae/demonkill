extends KinematicBody2D

class_name BaseAI

var state
onready var animatedSprite = $AnimatedSprite

# STATES:
enum {
	IDLE,
	WANDERING,
	NAVIGATING,
	FOLLOWING_PLAYER,
	PRE_ATTACK,
	ATTACKING,
	POST_ATTACK,
	TAKING_DAMAGE,
	PRE_DEATH,
	DEATH,
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
		PRE_DEATH:
			state_string = "PRE_DEATH"
		DEATH:
			state_string = "DEATH"
	return state_string

func _ready():
	initialiseConfig()

func initialiseConfig():
	pass

func _on_AnimatedSprite_animation_finished() -> void:
	handlePostAnimState()

func handlePostAnimState() -> void:
	pass
