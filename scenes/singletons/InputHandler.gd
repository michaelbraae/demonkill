extends Node2D

var velocity = Vector2()
var aim_vector = Vector2()

var using_mouse = true
var mute_inputs = false

var current_actor

func _ready():
	setDeadzones()
	pause_mode = Node.PAUSE_MODE_PROCESS

func getVelocity(move_speed) -> Vector2: 
	if mute_inputs:
		return velocity * move_speed
	return getMovementVector() * move_speed

func getMovementVector() -> Vector2:
	velocity.y = Input.get_action_strength('down') - Input.get_action_strength('up')
	velocity.x = Input.get_action_strength('right') - Input.get_action_strength('left')
	velocity = velocity.normalized()
	return velocity

func setDeadzones() -> void:
	InputMap.action_set_deadzone('aim_up', 0.1)
	InputMap.action_set_deadzone('aim_down', 0.1)
	InputMap.action_set_deadzone('aim_left', 0.1)
	InputMap.action_set_deadzone('aim_right', 0.1)
	InputMap.action_set_deadzone('up', 0.1)
	InputMap.action_set_deadzone('down', 0.1)
	InputMap.action_set_deadzone('left', 0.1)
	InputMap.action_set_deadzone('right', 0.1)

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
	return getMovementVector()

func _input(event) -> void:
	if event.is_action_pressed("reload_town"):
		LevelManager.goto_scene("res://scenes/levels/Town.tscn")
	if event.is_action_pressed("ui_accept"):
		InputEmitter.ui_accept()
	if event.is_action_pressed("action_1"):
		InputEmitter.action_1()
	if event.is_action_pressed("action_2"):
		InputEmitter.action_2()
	if event.is_action("action_3"):
		if event.is_pressed():
			InputEmitter.action_3_pressed()
		else:
			InputEmitter.action_3_released()
	if event.is_action_pressed("action_4"):
		InputEmitter.action_4()
	if event.is_action_pressed("dev_tool"):
		LevelManager.goto_scene("res://scenes/developer_tool/DeveloperTool.tscn")
	if event.is_action_pressed("ui_cancel"):
		InputEmitter.ui_cancel()
