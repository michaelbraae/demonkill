extends KinematicBody2D

class_name CharacterBase

# this script handles the knockback functionality and other things 

# --- KNOCKBACK LOGIC --- #
var knocked_back = false
var knockback_vector
var speed = 300
var speed_current = speed
var decay

func getKnockBackProcessVector() -> Vector2:
	if speed_current < 10:
		speed_current = speed
		knocked_back = false
	speed_current -= decay
	return knockback_vector.normalized() * speed_current

func knockBack(
	hit_direction : float,
	knock_back_speed : int,
	knock_back_decay : int
) -> void:
	if not knocked_back:
		knocked_back = true
		speed = knock_back_speed
		decay = knock_back_decay
		knockback_vector = Vector2(cos(hit_direction), sin(hit_direction))
