extends Node2D

onready var sprite = $Sprite

class_name WeaponRotation

func rotateWeapon() -> void:
	sprite.look_at(to_global(get_local_mouse_position()))

func positionWeapon() -> void:
	var weapon_aim_angle = rad2deg(get_angle_to(get_local_mouse_position()))
	var current_position = get_position()
	if get_local_mouse_position().x < get_position().x:
		sprite.flip_v = true
		set_position(Vector2(-15, 0))
	else:
		sprite.flip_v = false
		set_position(Vector2(0, 0))
#	if weapon_aim_angle < -45 and weapon_aim_angle > -135:
#		# UP
#		set_position(Vector2(4, -4))
#	elif weapon_aim_angle > 45 and weapon_aim_angle < 135:
#		# DOWN
#		pass
#	elif weapon_aim_angle > 135 or weapon_aim_angle < -135:
#		# LEFT
#		set_position(Vector2(0, 0))
#	elif weapon_aim_angle < 45 and weapon_aim_angle > -45:
#		# RIGHT
#		set_position(Vector2(0, 4))

func _physics_process(_delta):
	rotateWeapon()
	positionWeapon()
