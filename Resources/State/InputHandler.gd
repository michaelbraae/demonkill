extends Node2D

var velocity = Vector2()

var using_mouse = true

var aim_vector = Vector2()

var mute_inputs = false

var current_actor
const SPEED = 180

func getVelocity(move_speed) -> Vector2: 
	if mute_inputs:
		return Vector2()
	return getMoveDirection() * move_speed

func getMoveDirection() -> Vector2:
	velocity.y = Input.get_action_strength('down') - Input.get_action_strength('up')
	velocity.x = Input.get_action_strength('right') - Input.get_action_strength('left')
	velocity = velocity.normalized()
	return velocity

func setDeadzones() -> void:
	InputMap.action_set_deadzone('aim_up', 0.05)
	InputMap.action_set_deadzone('aim_down', 0.05)
	InputMap.action_set_deadzone('aim_left', 0.05)
	InputMap.action_set_deadzone('aim_right', 0.05)

func setMouseMode() -> void:
	if using_mouse:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func getAttackDirection() -> Vector2:
	if using_mouse:
		return Vector2(current_actor.get_local_mouse_position().normalized())
	aim_vector = Vector2()
	aim_vector.y = Input.get_action_strength('aim_down') - Input.get_action_strength('aim_up')
	aim_vector.x = Input.get_action_strength('aim_right') - Input.get_action_strength('aim_left')
	aim_vector = aim_vector.normalized()
	if aim_vector:
		return aim_vector
	return velocity

func _process(_delta):
	if Input.is_action_just_pressed('ui_cancel'):
		get_tree().quit()
