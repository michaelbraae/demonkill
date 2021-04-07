extends PlayerAnimation

class_name PlayerAction

var attacking = false

var melee_attack

var dash_timer
var dash_cooldown_timer
var dash_available = true
var dash_started = false
var dash_vector

enum MELEE_ATTACKS {
	BASIC,
}

var melee_node_moved = false

func _ready():
	dash_timer = Timer.new()
	dash_timer.connect('timeout', self, 'dash_timeout')
	add_child(dash_timer)
	dash_cooldown_timer = Timer.new()
	dash_cooldown_timer.connect('timeout', self, 'dash_cooldown_timeout')
	add_child(dash_cooldown_timer)
	melee_attack = MELEE_ATTACKS.BASIC

func dash_timeout() -> void:
	dash_timer.stop()
	dash_started = false
	state = DASH_RECOVERY

func dash_cooldown_timeout() -> void:
	dash_cooldown_timer.stop()
	dash_available = true

func _on_AttackSprite_animation_finished():
	attacking = false
	attackSprite.stop()
	attackSprite.hide()
	melee_node_moved = false
	use_facing_vector = false
	state = IDLE

func positionAttackNode() -> void:
	attackBox.look_at(to_global(getAttackDirection()))
	attackSprite.play('melee_basic')
	attackSprite.show()

func damageAndKnockBackOverlappingAreas() -> void:
	var overlappingAreas = $AttackBox/Area2D.get_overlapping_areas()
	if overlappingAreas:
		for area in overlappingAreas:
			if area.get_name() == 'EnemyHitBox':
				var area_parent = area.get_parent()
				camera2D.shake()
				area_parent.damage(1, true)
				area_parent.knockBack(
					get_angle_to(area_parent.get_global_position()),
					200,
					20
				)

func meleeAttack():
	match melee_attack:
		MELEE_ATTACKS.BASIC:
			if not melee_node_moved:
				melee_node_moved = true
				positionAttackNode()
			else:
				melee_node_moved = false
				damageAndKnockBackOverlappingAreas()
	state = ATTACKING

func _physics_process(_delta : float) -> void:
	handlePlayerAction()

func getVectorFromFacingDirection() -> Vector2:
	match facing_direction:
		'up':
			return Vector2.UP
		'right':
			if animatedSprite.flip_h:
				return Vector2.LEFT
			else:
				return Vector2.RIGHT
		'down':
			return Vector2.DOWN
	return Vector2()

func handlePlayerAction() -> void:
	if state == DASH:
		if not dash_started:
			dash_started = true
			if velocity:
				dash_vector = InputHandler.getMovementVector()
			else:
				dash_vector = getVectorFromFacingDirection()
			velocity = dash_vector * 450
	elif state == DASH_RECOVERY:
		velocity = dash_vector * 50
	elif Input.is_action_just_pressed('dash') and dash_available:
		dash_available = false
		state = DASH
		dash_cooldown_timer.start(0.4)
		dash_timer.start(0.15)
	else:
		if Input.is_action_just_pressed('melee_attack') or melee_node_moved:
			meleeAttack()
		else:
			setVelocity()
	animatedSprite.play(getAnimation())
	velocity = move_and_slide(velocity)
