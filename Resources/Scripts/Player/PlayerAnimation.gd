extends PlayerNavigation

class_name PlayerAnimation

var attack_order = false

func setFacingDirection(angle_of_focus : int) -> void:
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

func getAnimationFromAngleOfFocus(angle_of_focus : int) -> String:
	setFacingDirection(angle_of_focus)
	return 'run_' + facing_direction + '_axe'

func getAttackOrder() -> String:
	if attack_order:
		return '1'
	return '2'

func getAttackAnimation() -> String:
	var phase
	match state:
		ATTACK_WARMUP:
			phase = 'warmup_'
		ATTACK_CONTACT:
			phase = 'contact_'
		ATTACK_RECOVERY:
			phase = 'recovery_'
	if facing_direction == 'right':
		return 'attack_axe_' +  phase + facing_direction + '_' + getAttackOrder()
	if attack_order:
		animatedSprite.flip_h = true
	else:
		animatedSprite.flip_h = false
	return 'attack_axe_' +  phase + facing_direction

func getAnimation() -> String:
	var animation = 'idle_'
	if state == DASH:
		animation = 'dash_'
	elif state == DASH_RECOVERY:
		animation = 'dash_recovery_'
	elif ATTACK_STATES.has(state):
		return getAttackAnimation()
	elif velocity:
		return getAnimationFromAngleOfFocus(round(rad2deg(velocity.angle())))
	else:
		return animation + facing_direction + '_axe'
	return animation + facing_direction

func _on_AnimatedSprite_animation_finished():
	if state == DASH_RECOVERY:
		state = IDLE
		animatedSprite.play(str('idle_', facing_direction))
	elif state == ATTACK_WARMUP:
		state = ATTACK_CONTACT
		animatedSprite.play(getAttackAnimation())
	elif state == ATTACK_CONTACT:
		state = ATTACK_RECOVERY
		animatedSprite.play(getAttackAnimation())
	elif state == ATTACK_RECOVERY:
		animatedSprite.play(str('idle_', facing_direction))
		state = IDLE
