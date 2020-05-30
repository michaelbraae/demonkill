extends Node

var using_mouse = false

#
#var aim_vector
#var velocity
#var facing_direction = "down"
## sets the aiming deadzones so you can accurately aim
## movement deadzones should be left at default, they cause fuckiness
func setDeadzones():
	InputMap.action_set_deadzone("aim_up", 0.05)
	InputMap.action_set_deadzone("aim_down", 0.05)
	InputMap.action_set_deadzone("aim_left", 0.05)
	InputMap.action_set_deadzone("aim_right", 0.05)

func mouseLogic() -> void:
	if using_mouse:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

#
#func getAttackDirection() -> Vector2:
#	# should eventually handle mouse aiming
#	aim_vector = Vector2()
#	aim_vector.y = Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")
#	aim_vector.x = Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left")
#	aim_vector = aim_vector.normalized()
#	if aim_vector:
#		return aim_vector
#	if velocity:
#		return velocity
#	var facing_vector = Vector2()
#	match facing_direction:
#		"up":
#			facing_vector.y = -1
#		"down":
#			facing_vector.y = 1
#		"right":
#			if animatedSprite.flip_h:
#				facing_vector.x = -1
#			else:
#				facing_vector.x = 1
#	return facing_vector.normalized()
#
#func setVelocity() -> void:
#	velocity = Vector2()
#	if knockback_handler.getKnockedBack():
#		velocity = knockback_handler.getKnockBackProcessVector()
#	else:
#		velocity.y = Input.get_action_strength("down") - Input.get_action_strength("up")
#		velocity.x = Input.get_action_strength("right") - Input.get_action_strength("left")
#		if Input.is_action_just_pressed("dash") and dash_cooldown_timer.is_stopped():
#			dash_cooldown_timer.start(DASH_COOLDOWN)
#			bolt_cooldown_timer.stop()
#			collisionShape.set_disabled(true)
#			speed_actual = SPEED * 20
#		else:
#			collisionShape.set_disabled(false)
#			speed_actual = SPEED
#		velocity = velocity.normalized() * speed_actual
#var dash_cooldown_timer
#var bolt_cooldown_timer
#var speed_actual
#const SPEED = 150
#const DASH_COOLDOWN = 0.7
#
#func _ready():
#	dash_cooldown_timer = Timer.new()
#
#func getVelocity(collisionShape) -> Vector2:
#	var velocity = Vector2()
#	velocity.y = Input.get_action_strength("down") - Input.get_action_strength("up")
#	velocity.x = Input.get_action_strength("right") - Input.get_action_strength("left")
#	if Input.is_action_just_pressed("dash") and dash_cooldown_timer.is_stopped():
#		dash_cooldown_timer.start(DASH_COOLDOWN)
#		bolt_cooldown_timer.stop()
#		collisionShape.set_disabled(true)
#		speed_actual = SPEED * 20
#	else:
#		collisionShape.set_disabled(false)
#		speed_actual = SPEED
#	return velocity.normalized() * speed_actual
