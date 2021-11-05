extends KinematicBody2D

var target_vector : Vector2
var projectile_speed : int = 300

func setCollideWithEnemies() -> void:
	set_collision_mask(3)
	set_collision_layer(3)
	print("mask: ", get_collision_mask())
	print("layer: ", get_collision_layer())

func setCollideWithPlayer():
	set_collision_mask(2)
	set_collision_layer(2)

func _physics_process(delta):
	var collision = move_and_collide(target_vector * projectile_speed * delta)
	if collision:
		queue_free()
		print('Collision detected!')
