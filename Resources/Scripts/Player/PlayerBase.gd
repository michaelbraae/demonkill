extends KinematicBody2D

class_name PlayerBase

onready var GameState = get_node("/root/GameState")
onready var PlayerState = get_node("/root/PlayerState")
onready var InputHandler = get_node("/root/InputHandler")

var possessing = false

onready var animatedSprite = $AnimatedSprite
onready var collisionShape = $CollisionShape2D
onready var healthBar = $HealthBar
onready var camera2D = $Camera2D
onready var attackSprite = $AttackBox/AttackSprite
onready var attackBox = $AttackBox
onready var attackBoxArea2D = $AttackBox/Area2D

const IS_PLAYER = true

var state

func setState(state_var : int) -> void:
	state = state_var

func getState() -> int:
	return state

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
