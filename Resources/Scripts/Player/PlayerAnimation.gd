extends PlayerNavigation

class_name PlayerAnimation

func getAnimation() -> String:
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
