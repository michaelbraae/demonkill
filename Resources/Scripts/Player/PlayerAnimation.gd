extends PlayerNavigation

class_name PlayerAnimation

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

func getAnimation() -> String:
	if state == DASH:
		return 'dash_' + facing_direction
	if state == DASH_RECOVERY:
		return 'dash_recovery_' + facing_direction
	if velocity:
		var angle_of_focus
		angle_of_focus = round(rad2deg(velocity.angle()))
		return getAnimationFromAngleOfFocus(angle_of_focus)
	else:
		return 'idle_' + facing_direction

func _on_AnimatedSprite_animation_finished():
	if state == DASH_RECOVERY:
		animatedSprite.play(str('idle_', facing_direction))
		state = IDLE

