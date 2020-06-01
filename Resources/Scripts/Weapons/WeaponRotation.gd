extends Node2D

onready var sprite = $Sprite

class_name WeaponRotation

func rotateWeapon() -> void:
	sprite.look_at(to_global(get_local_mouse_position()))

func positionWeapon() -> void:
	var weapon_aim_angle = rad2deg(get_angle_to(get_global_mouse_position()))
	if weapon_aim_angle > 15 and weapon_aim_angle < 55:
		sprite.flip_v = false
		set_position(Vector2(-3, 0))
#		print("DOWN RIGHT")
	if weapon_aim_angle >= 55 and weapon_aim_angle < 90:
		sprite.flip_v = false
		set_position(Vector2(-3, 0))
#		print("DOWN DOWN RIGHT")
	elif weapon_aim_angle <= 15 and weapon_aim_angle >= 0:
#		set_position(Vector2(0, -10))
		sprite.flip_v = false
#		print("RIGHT")
	elif weapon_aim_angle < 0 and weapon_aim_angle > -90:
		sprite.flip_v = false
		set_position(Vector2(0, -5))
#		print("UP RIGHT")
	elif weapon_aim_angle <= -90 and weapon_aim_angle > -180:
		sprite.flip_v = true
		set_position(Vector2(-10, -5))
#		print("UP LEFT")
#		55 -> 90 90 -> 115
	elif weapon_aim_angle <= 180 and weapon_aim_angle >= 135: #165
		sprite.flip_v = true
		set_position(Vector2(-10, 0))
#		print("LEFT")
	elif weapon_aim_angle > 115 and weapon_aim_angle < 135:
		sprite.flip_v = true
#		print("DOWN LEFT")
		set_position(Vector2(-10, 0))
	elif weapon_aim_angle >= 90 and weapon_aim_angle <= 115:
		pass
#		print("DOWN DOWN LEFT")

func _physics_process(_delta):
	rotateWeapon()
	positionWeapon()
