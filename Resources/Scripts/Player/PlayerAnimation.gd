extends PlayerNavigation

class_name PlayerAnimation

func getAnimation() -> String:
#	print(rad2deg(getAttackDirection().angle()))
	var aiming_angle = rad2deg(getAttackDirection().angle())
	if aiming_angle < -30 and aiming_angle > -150:
		return "walk_up"
#	var aiming_angle = get_angle_to(get_global_mouse_position())
	if velocity.y <= -45:
		animatedSprite.flip_h = false
		facing_direction = "up"
		return "walk_up"
	if velocity.y >= 45:
		animatedSprite.flip_h = false
		facing_direction = "down"
		return "walk_down"
	if velocity.x >= 45:
		animatedSprite.flip_h = false
		facing_direction = "right"
		return "walk_right"
	if velocity.x <= -45:
		animatedSprite.flip_h = true
		facing_direction = "right"
		return "walk_right"
	return "idle_" + facing_direction
