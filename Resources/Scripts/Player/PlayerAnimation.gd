extends PlayerWeapon

class_name PlayerAnimation

func getAnimation() -> String: 
	var is_weapon_equipped = current_weapon.isEquipped()
	var aiming_angle = round(rad2deg(getAttackDirection().angle()))
	var high_angle_node_position
	var low_angle_node_position
	if current_weapon.isEquipped():
		high_angle_node_position = 0
		low_angle_node_position = 1
	else:
		high_angle_node_position = 1
		low_angle_node_position = 0
	if aiming_angle < -30 and aiming_angle > -150:
		move_child(current_weapon, high_angle_node_position)
		animatedSprite.flip_h = false
		facing_direction = "up"
	if aiming_angle < -30 and aiming_angle > -70:
		move_child(current_weapon, high_angle_node_position)
		animatedSprite.flip_h = false
		facing_direction = "up_right"
	if aiming_angle < -120 and aiming_angle > -150:
		move_child(current_weapon, high_angle_node_position)
		animatedSprite.flip_h = true
		facing_direction = "up_right"
	elif aiming_angle >= -30 and aiming_angle < 30:
		move_child(current_weapon, low_angle_node_position)
		animatedSprite.flip_h = false
		facing_direction = "right"
	elif aiming_angle >= 30 and aiming_angle <= 150:
		move_child(current_weapon, low_angle_node_position)
		animatedSprite.flip_h = false
		facing_direction = "down"
	elif aiming_angle > 150 or aiming_angle < -150:
		move_child(current_weapon, low_angle_node_position)
		animatedSprite.flip_h = true
		facing_direction = "right"
	
	# should also account for moving backward
	
	if facing_direction == "up_right":
		animatedSprite.set_speed_scale(1.5)
	else:
		animatedSprite.set_speed_scale(2)
	
#	var move_direction
#	if velocity.y <= -45:
#		move_direction = "up"
#	elif velocity.y >= 45:
#		move_direction = "down"
#	elif velocity.x >= 45:
#		move_direction = "right"
#	elif velocity.x <= -45:
#		move_direction = "left"
	if velocity:
		return "walk_" + facing_direction
	return "idle_" + facing_direction
