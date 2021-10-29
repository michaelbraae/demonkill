extends KinematicBody2D

var target_vector : Vector2
var projectile_speed : int = 300

func _physics_process(_delta):
	var collider = move_and_slide(target_vector * projectile_speed)
	if collider:
		print('Collision detected!')
