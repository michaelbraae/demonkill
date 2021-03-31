extends PlayerWeapon

class_name PlayerAnimation

func getAnimationFromAngleOfFocus(angle_of_focus : int) -> String:
	var high_angle_node_position
	var low_angle_node_position
	if current_weapon.isEquipped():
		high_angle_node_position = 0
		low_angle_node_position = 1
	else:
		high_angle_node_position = 1
		low_angle_node_position = 0
	
	if angle_of_focus < -30 and angle_of_focus > -150:
		move_child(current_weapon, high_angle_node_position)
		animatedSprite.flip_h = false
		facing_direction = 'up'
	elif angle_of_focus >= -30 and angle_of_focus < 30:
		move_child(current_weapon, low_angle_node_position)
		animatedSprite.flip_h = false
		facing_direction = 'right'
	elif angle_of_focus >= 30 and angle_of_focus <= 150:
		move_child(current_weapon, low_angle_node_position)
		animatedSprite.flip_h = false
		facing_direction = 'down'
	elif angle_of_focus > 150 or angle_of_focus < -150:
		move_child(current_weapon, low_angle_node_position)
		animatedSprite.flip_h = true
		facing_direction = 'right'
	if velocity:
		return 'run_' + facing_direction
	return 'idle_' + facing_direction

func getAnimation() -> String:
	var angle_of_focus
	if current_weapon.isEquipped():
		angle_of_focus = round(rad2deg(getAttackDirection().angle()))
	else:
		angle_of_focus = round(rad2deg(velocity.angle()))
	return getAnimationFromAngleOfFocus(angle_of_focus)
