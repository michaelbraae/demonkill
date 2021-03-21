extends KinematicBody2D

class_name PlayerBase

onready var GameState = get_node('/root/GameState')
onready var PlayerState = get_node('/root/PlayerState')
onready var InputHandler = get_node('/root/InputHandler')

onready var animatedSprite = $AnimatedSprite
onready var collisionShape = $CollisionShape2D
onready var camera2D = $Camera2D
onready var attackSprite = $AttackBox/AttackSprite
onready var attackBox = $AttackBox

const IS_PLAYER = true

var state

enum {
	MOVING,
	IDLE,
	ATTACKING,
	ROLLING,
	DAMAGED,
	POSSESSING,
}

func _ready() -> void:
	GameState.prepareHealthGUI()
	attackSprite.hide()

func damage(damage : int) -> void:
	PlayerState.health -= damage
	if PlayerState.health <= 0:
		get_tree().quit()
