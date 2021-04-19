extends KinematicBody2D

class_name PlayerBase

onready var GameState = get_node('/root/GameState')
onready var PlayerState = get_node('/root/PlayerState')
onready var InputHandler = get_node('/root/InputHandler')
onready var FeedbackHandler = get_node('/root/FeedbackHandler')
onready var PossessionState = get_node('/root/PossessionState')

onready var animatedSprite = $AnimatedSprite
onready var collisionShape = $CollisionShape2D
onready var camera2D = $Camera2D
onready var bite_box = $BiteBox

const IS_PLAYER = true

var state

enum {
	IDLE,
	NAVIGATING,
	ATTACK_WARMUP,
	ATTACK_CONTACT,
	ATTACK_RECOVERY,
	ATTACKING,
	AXE_THROW,
	AXE_RECALL,
	DASH,
	DASH_RECOVERY,
}

const ATTACK_STATES = [ATTACK_WARMUP, ATTACK_CONTACT, ATTACK_RECOVERY]

func getStateString() -> String:
	var state_string = 'NO_STATE'
	match state:
		NAVIGATING:
			state_string = 'NAVIGATING'
		IDLE:
			state_string = 'IDLE'
		ATTACKING:
			state_string = 'ATTACKING'
		DASH:
			state_string = 'DASH'
		DASH_RECOVERY:
			state_string = 'DASH_RECOVERY'
	return state_string

func _ready() -> void:
	InputHandler.current_actor = self
	GameState.prepareHealthGUI()
	FeedbackHandler.current_camera = camera2D
	PossessionState.bite_box = bite_box
\
func damage(damage : int) -> void:
	PlayerState.health -= damage
	if PlayerState.health <= 0:
		get_tree().quit()
