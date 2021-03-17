extends KinematicBody2D

class_name PlayerBase

onready var GameState = get_node("/root/GameState")
onready var PlayerState = get_node("/root/PlayerState")
onready var InputHandler = get_node("/root/InputHandler")

var possessing = false

onready var animatedSprite = $AnimatedSprite
onready var interactButton = $InteractButton
onready var interactArea = $InteractArea
onready var collisionShape = $CollisionShape2D
onready var healthBar = $HealthBar
onready var camera2D = $Camera2D
onready var attackSprite = $AttackBox/AttackSprite
onready var attackBox = $AttackBox
onready var attackBoxArea2D = $AttackBox/Area2D

const IS_PLAYER = true

const HEALTH_MAX = 10
const HEALTH_MIN = 0

var health_current = HEALTH_MAX

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
	attackSprite.hide()

func damage(damage : int) -> void:
	health_current = health_current - damage
	if health_current <= HEALTH_MIN:
		get_tree().reload_current_scene()
