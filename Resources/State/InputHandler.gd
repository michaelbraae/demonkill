extends Node2D

var velocity = Vector2()

var using_mouse = true

var current_actor
const SPEED = 180

func getVelocity() -> Vector2: 
	velocity.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	velocity.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	velocity = velocity.normalized() * SPEED
	return velocity



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

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
