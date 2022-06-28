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

# Elemental states
enum {
	IDLE,
	FROZEN
}

var freeze_timer: Timer

func _ready() -> void:
	freeze_timer = Timer.new()
	freeze_timer.connect("timeout", self, "freeze_timeout")
	pass

func freeze_timeout() -> void:
	freeze_timer.stop()
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
	state = FROZEN
	freeze_timer.start(freeze_duration)
