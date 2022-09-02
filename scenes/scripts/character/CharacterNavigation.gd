extends CharacterBase

class_name CharacterNavigation

var velocity = Vector2()

var aim_vector = Vector2()

var attack_movement_vector: Vector2 = Vector2()

var facing_direction = 'down'

var use_facing_vector = false

export var dash_cooldown: float = 2.0
export var dash_duration: float = 0.15

export(Curve) var speed_up_curve
export(Curve) var slow_down_curve

var dash_timer
var dash_cooldown_timer
var dash_available = true
var dash_started = false
var dash_vector

var possession_dash_vector

func _ready() -> void:
	InputHandler.setMouseMode()
	dash_timer = Timer.new()
	dash_timer.connect('timeout', self, 'dash_timeout')
	add_child(dash_timer)
	dash_cooldown_timer = Timer.new()
	dash_cooldown_timer.connect('timeout', self, 'dash_cooldown_timeout')
	add_child(dash_cooldown_timer)

func on_dash_continuous() -> void:
	pass

func dash_timeout() -> void:
	set_collision_layer_bit(1, true)
	set_collision_mask_bit(1, true)
	dash_timer.stop()
	dash_started = false
	state = DASH_RECOVERY

func dash_cooldown_timeout() -> void:
	dash_cooldown_timer.stop()
	dash_available = true

func movement_ability() -> void:
	initiate_dash()

func initiate_dash() -> void:
	if dash_available:
		FeedbackHandler.shake_camera(0.2, 0.8)
		set_collision_layer_bit(1, false)
		set_collision_mask_bit(1, false)
		dash_available = false
		state = DASH
		dash_cooldown_timer.start(dash_cooldown)
		dash_timer.start(dash_duration)
		dash_vector = InputHandler.getMovementVector()

func continueDash() -> void:
	on_dash_continuous()
	if not dash_started:
		dash_started = true
		if state == POSSESSION_DASH:
			dash_vector = possession_dash_vector
		elif not velocity:
			dash_vector = getVectorFromFacingDirection()
		velocity = dash_vector * 450

func set_player_input_velocity() -> void:
	velocity = Vector2()
	if state == DASH and not knocked_back:
		velocity = InputHandler.getVelocity(130)
	elif ATTACK_STATES.has(state):
		if !attack_movement_vector:
			attack_movement_vector = InputHandler.getAttackDirection()
			# warning-ignore:narrowing_conversion
			set_facing_direction(round(rad2deg(InputHandler.getAttackDirection().angle())))
		velocity = attack_movement_vector * 10
	elif knocked_back:
		velocity = getKnockBackProcessVector()
	else:
		velocity = InputHandler.getVelocity(speed)
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

func set_facing_direction(angle_of_focus : int) -> void:
	if angle_of_focus < -30 and angle_of_focus > -150:
		animatedSprite.flip_h = false
		facing_direction = 'up'
	elif angle_of_focus >= -30 and angle_of_focus < 30:
		animatedSprite.flip_h = false
		facing_direction = 'right'
	elif angle_of_focus >= 30 and angle_of_focus <= 150:
		animatedSprite.flip_h = false
		facing_direction = 'down'
	elif angle_of_focus > 150 or angle_of_focus < -150:
		animatedSprite.flip_h = true
		facing_direction = 'right'
