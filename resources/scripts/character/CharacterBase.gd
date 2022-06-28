extends KinematicBody2D

class_name CharacterBase

# this script handles the knockback functionality and other things 

# --- KNOCKBACK LOGIC --- #
var knocked_back = false
var knockback_vector
var speed = 300
var speed_current = speed
var decay

var state

onready var animatedSprite = $AnimatedSprite

# Elemental states
enum {
	IDLE,
	FROZEN
}

var freeze_timer: Timer

func _ready() -> void:
	freeze_timer = Timer.new()
	freeze_timer.connect("timeout", self, "freeze_timeout")
	add_child(freeze_timer)


func _unhandled_input(event):
	if event.is_action_pressed("freeze"):
		freeze(3.0)

func freeze_timeout() -> void:
	print("freeze timeout")
	freeze_timer.stop()
	self_modulate
	state = IDLE

func getKnockBackProcessVector() -> Vector2:
	if speed_current < 10:
		speed_current = speed
		knocked_back = false
	speed_current -= decay
	return knockback_vector.normalized() * speed_current

func interruptAction() -> void:
	pass

func knockBack(
	hit_direction : float,
	knock_back_speed : int,
	knock_back_decay : int
) -> void:
	if not knocked_back:
		interruptAction()
		knocked_back = true
		speed = knock_back_speed
		decay = knock_back_decay
		knockback_vector = Vector2(cos(hit_direction), sin(hit_direction))

func freeze(freeze_duration: float) -> void:
	print("start freeze")
	state = FROZEN
	animatedSprite.self_modulate = COLOR.FREEZE
	freeze_timer.start(freeze_duration)
