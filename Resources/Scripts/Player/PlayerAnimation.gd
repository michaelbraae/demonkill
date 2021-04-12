extends PlayerNavigation

class_name PlayerAnimation

var attack_order = false

func getAnimationFromAngleOfFocus(angle_of_focus : int) -> String:
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
	return 'run_' + facing_direction

func getAttackOrder() -> String:
	if attack_order:
		return '1'
	attack_order = !attack_order
	return '2'

func getAttackAnimation() -> String:
	var phase
	match state:
		ATTACK_WARMUP:
			phase = 'attack_warmup_'
		ATTACK_CONTACT:
			phase = 'attack_contact_'
		ATTACK_RECOVERY:
			phase = 'attack_recovery_'
	if facing_direction == 'right':
		return phase + facing_direction + '_1'
	return phase + facing_direction

func getAnimation() -> String:
	var animation = 'idle_'
	if state == DASH:
		animation = 'dash_'
	elif state == DASH_RECOVERY:
		animation = 'dash_recovery_'
	elif ATTACK_STATES.has(state):
		return getAttackAnimation()
	elif velocity:
		var angle_of_focus
		angle_of_focus = round(rad2deg(velocity.angle()))
		return getAnimationFromAngleOfFocus(angle_of_focus)
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
