extends KinematicBody2D

var target_vector : Vector2
var projectile_speed : int = 300
var instigator

func _physics_process(delta):
	var collision = move_and_collide(target_vector * projectile_speed * delta)
	if collision and collision.get_collider() != instigator:
		print('Collision detected!')
