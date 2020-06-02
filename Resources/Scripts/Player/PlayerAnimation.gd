extends PlayerNavigation

class_name PlayerAnimation

func getAnimation() -> String:
	var aiming_angle = rad2deg(getAttackDirection().angle())
	var facing_direction
#	print("aiming_angle: ", aiming_angle)
	if aiming_angle < -30 and aiming_angle > -150:
#		-120 -70
		move_child($PumpShotgun, 0)
		animatedSprite.flip_h = false
		facing_direction = "up"
	if aiming_angle < -30 and aiming_angle > -70:
		move_child($PumpShotgun, 0)
		animatedSprite.flip_h = false
		facing_direction = "up_right"
		print("UP RIGHT")
	if aiming_angle < -120 and aiming_angle > -150:
		move_child($PumpShotgun, 0)
		animatedSprite.flip_h = true
		facing_direction = "up_right"
		print("UP LEFT")
	elif aiming_angle >= -30 and aiming_angle < 30:
		move_child($PumpShotgun, 1)
		animatedSprite.flip_h = false
		facing_direction = "right"
	elif aiming_angle >= 30 and aiming_angle <= 150:
		move_child($PumpShotgun, 1)
		animatedSprite.flip_h = false
		facing_direction = "down"
	elif aiming_angle > 150 or aiming_angle < -150:
		move_child($PumpShotgun, 1)
		animatedSprite.flip_h = true
		facing_direction = "right"

	var move_direction
	if velocity.y <= -45:
		move_direction = "up"
	elif velocity.y >= 45:
		move_direction = "down"
	elif velocity.x >= 45:
		move_direction = "right"
	elif velocity.x <= -45:
		move_direction = "left"
	if velocity:
		return "walk_" + facing_direction
	return "idle_" + facing_direction
