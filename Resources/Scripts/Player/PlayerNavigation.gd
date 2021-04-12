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
	elif ATTACK_STATES.has(state):
		velocity = InputHandler.getAttackDirection()
		if not velocity:
			velocity = getVectorFromFacingDirection()
		velocity = velocity * 10
	elif knockback_handler.knocked_back:
		velocity = knockback_handler.getKnockBackProcessVector()
	else:
		velocity = InputHandler.getVelocity(SPEED)
		if velocity:
			state = NAVIGATING
		else:
			state = IDLE

func getVectorFromFacingDirection() -> Vector2:
	match facing_direction:
		'up':
			return Vector2.UP
		'right':
			if animatedSprite.flip_h:
				return Vector2.LEFT
			return Vector2.RIGHT
		'down':
			return Vector2.DOWN
	return Vector2()

func getAttackDirection() -> Vector2:
	if InputHandler.using_mouse:
		return Vector2(get_local_mouse_position().normalized())
	aim_vector = Vector2()
	aim_vector.y = Input.get_action_strength('aim_down') - Input.get_action_strength('aim_up')
	aim_vector.x = Input.get_action_strength('aim_right') - Input.get_action_strength('aim_left')
	aim_vector = aim_vector.normalized()
	if aim_vector:
		return aim_vector
	if velocity:
		return velocity
	return getVectorFromFacingDirection()
