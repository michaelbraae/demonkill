extends Node2D

onready var sprite = $Sprite
onready var muzzle = $Muzzle

class_name WeaponRotation

const MUZZLE_RIGHT = Vector2(17, -2.5)
const MUZZLE_LEFT = Vector2(-9, -2.5)

func flipLeft() -> void:
	sprite.flip_v = true
	muzzle.set_position(MUZZLE_LEFT)
	
func flipRight() -> void:
	sprite.flip_v = false
	muzzle.set_position(MUZZLE_RIGHT)

func rotateWeapon() -> void:
	sprite.look_at(to_global(get_local_mouse_position()))

func positionWeapon() -> void:
	var weapon_aim_angle = rad2deg(get_angle_to(get_global_mouse_position()))
	if weapon_aim_angle > 15 and weapon_aim_angle < 55:
		flipRight()
		set_position(Vector2(-3, 0))
		# down right
	if weapon_aim_angle >= 55 and weapon_aim_angle < 90:
		flipRight()
		set_position(Vector2(-3, 0))
		# down down right
	elif weapon_aim_angle <= 15 and weapon_aim_angle >= 0:
		flipRight()
		# right
	elif weapon_aim_angle < 0 and weapon_aim_angle > -90:
		flipRight()
		set_position(Vector2(0, -5))
		# up right
	elif weapon_aim_angle <= -90 and weapon_aim_angle > -180:
		flipLeft()
		set_position(Vector2(-10, -5))
		# up left
	elif weapon_aim_angle <= 180 and weapon_aim_angle >= 135: #165
		flipLeft()
		set_position(Vector2(-10, 0))
		# left
	elif weapon_aim_angle > 115 and weapon_aim_angle < 135:
		flipLeft()
		set_position(Vector2(-10, 0))
		# down left
	elif weapon_aim_angle >= 90 and weapon_aim_angle <= 115:
		flipLeft()
		set_position(Vector2(-10, 0))
#		down down left

func _physics_process(_delta):
	rotateWeapon()
	positionWeapon()
