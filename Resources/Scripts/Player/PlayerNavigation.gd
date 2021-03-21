extends PlayerBase

class_name PlayerNavigation

var velocity = Vector2()

var dash_cooldown_timer
var bolt_cooldown_timer
const SPEED = 180
var speed_actual

const DASH_COOLDOWN = 0.7
const BOLT_COOLDOWN = 2.0

var knockback_handler_script = preload('res://Resources/Scripts/Helpers/KnockBackHandler.gd')
var knockback_handler

var aim_vector = Vector2()

var facing_direction = 'down'

func _ready():
	knockback_handler = knockback_handler_script.new()
	InputHandler.setDeadzones()
	InputHandler.setMouseMode()
	dash_cooldown_timer = Timer.new()
	add_child(dash_cooldown_timer)
	bolt_cooldown_timer = Timer.new()
	add_child(bolt_cooldown_timer)

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
	if knockback_handler.knocked_back:
		velocity = knockback_handler.getKnockBackProcessVector()
	else:
		velocity = InputHandler.getVelocity(SPEED)

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
	var facing_vector = Vector2()
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
	return facing_vector.normalized()

func _process(_delta : float) -> void:
	if dash_cooldown_timer.get_time_left() <= 0.1:
		dash_cooldown_timer.stop()
	if bolt_cooldown_timer.get_time_left() <= 0.1:
		bolt_cooldown_timer.stop()
