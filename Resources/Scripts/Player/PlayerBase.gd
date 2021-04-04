extends KinematicBody2D

class_name PlayerBase

onready var GameState = get_node('/root/GameState')
onready var PlayerState = get_node('/root/PlayerState')
onready var InputHandler = get_node('/root/InputHandler')
onready var PossessionState = get_node('/root/PossessionState')

onready var animatedSprite = $AnimatedSprite
onready var collisionShape = $CollisionShape2D
onready var camera2D = $Camera2D
onready var attackSprite = $AttackBox/AttackSprite
onready var attackBox = $AttackBox
onready var bite_box = $BiteBox

const IS_PLAYER = true

var state

enum {
	MOVING,
	IDLE,
	ATTACKING,
	DASH,
	DAMAGED,
	POSSESSING,
}

func _ready() -> void:
	InputHandler.current_actor = self
	GameState.prepareHealthGUI()
	PossessionState.bite_box = bite_box
	attackSprite.hide()

func damage(damage : int) -> void:
	camera2D.shake()
	PlayerState.health -= damage
	if PlayerState.health <= 0:
		get_tree().quit()
