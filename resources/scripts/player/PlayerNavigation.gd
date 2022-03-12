extends PlayerBase

class_name PlayerNavigation

var velocity = Vector2()

const SPEED = 100
var speed_actual

var aim_vector = Vector2()

var facing_direction = 'down'

var use_facing_vector = false

var dash_timer
var dash_cooldown_timer
var dash_available = true
var dash_started = false
var dash_vector

func _ready() -> void:
	InputHandler.setMouseMode()
	dash_timer = Timer.new()
	dash_timer.connect('timeout', self, 'dash_timeout')
	add_child(dash_timer)
	dash_cooldown_timer = Timer.new()
	dash_cooldown_timer.connect('timeout', self, 'dash_cooldown_timeout')
	add_child(dash_cooldown_timer)

func dash_timeout() -> void:
	dash_timer.stop()
	dash_started = false
	state = DASH_RECOVERY

func dash_cooldown_timeout() -> void:
	dash_cooldown_timer.stop()
	dash_available = true

func initiateDash() -> void:
	dash_available = false
	state = DASH
	dash_cooldown_timer.start(0.4)
	dash_timer.start(0.15)

func continueDash() -> void:
	if not dash_started:
		dash_started = true
		if velocity:
			dash_vector = InputHandler.getMovementVector()
		else:
			dash_vector = getVectorFromFacingDirection()
		velocity = dash_vector * 450

func setVelocity() -> void:
	velocity = Vector2()
	if state == DASH and not knocked_back:
		velocity = InputHandler.getVelocity(130)
	elif ATTACK_STATES.has(state):
		velocity = InputHandler.getAttackDirection()
		if not velocity:
			velocity = getVectorFromFacingDirection()
		velocity = velocity * 10
	elif knocked_back:
		velocity = getKnockBackProcessVector()
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
		return get_local_mouse_position().normalized()
	aim_vector = Vector2()
	aim_vector.y = Input.get_action_strength('aim_down') - Input.get_action_strength('aim_up')
	aim_vector.x = Input.get_action_strength('aim_right') - Input.get_action_strength('aim_left')
	aim_vector = aim_vector.normalized()
	if aim_vector:
		return aim_vector
	if velocity:
		return velocity
	return getVectorFromFacingDirection()
