extends KinematicBody2D

var target_vector : Vector2
var projectile_speed : int = 300

func setCollideWithEnemies() -> void:
	set_collision_mask(4)
	set_collision_layer(4)

func setCollideWithPlayer() -> void:
	set_collision_mask(2)
	set_collision_layer(2)

func _physics_process(delta):
	var collision = move_and_collide(target_vector * projectile_speed * delta)
	if collision:
		queue_free()
		print('Collision detected!')
