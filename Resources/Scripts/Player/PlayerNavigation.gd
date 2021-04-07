extends PlayerBase

class_name PlayerNavigation

var velocity = Vector2()

const SPEED = 100
var speed_actual

var knockback_handler_script = preload('res://Resources/Scripts/Helpers/KnockBackHandler.gd')
var knockback_handler

var aim_vector = Vector2()

var facing_direction = 'down'

var use_facing_vector = false

func _ready():
	knockback_handler = knockback_handler_script.new()
	InputHandler.setDeadzones()
	InputHandler.setMouseMode()

func knockBack(
	hit_direction : float,
	knock_back_speed : int,
	knock_back_decay : int
) -> void:
	knockback_handler.knockBack(
		hit_direction,
		knock_back_speed,
		knock_back_decay
	)

func setVelocity() -> void:
	velocity = Vector2()
	if state == DASH:
		velocity = InputHandler.getVelocity(130)
	elif state == ATTACKING:
		velocity = InputHandler.getVelocity(50)
	elif knockback_handler.knocked_back:
		velocity = knockback_handler.getKnockBackProcessVector()
	else:
		velocity = InputHandler.getVelocity(SPEED)
		if velocity:
			state = NAVIGATING
		else:
			state = IDLE

func getAttackDirection() -> Vector2:
	if InputHandler.using_mouse:
		return Vector2(get_local_mouse_position().normalized())
	if not use_facing_vector:
		aim_vector = Vector2()
		aim_vector.y = Input.get_action_strength('aim_down') - Input.get_action_strength('aim_up')
		aim_vector.x = Input.get_action_strength('aim_right') - Input.get_action_strength('aim_left')
		aim_vector = aim_vector.normalized()
		if aim_vector:
			return aim_vector
		if velocity:
			return velocity
	var facing_vector = Vector2()
	use_facing_vector = true
	match facing_direction:
		'up':
			facing_vector = Vector2.UP
		'down':
			facing_vector = Vector2.DOWN
		'right':
			if animatedSprite.flip_h:
				facing_vector = Vector2.LEFT
			else:
				facing_vector = Vector2.RIGHT
	return facing_vector
