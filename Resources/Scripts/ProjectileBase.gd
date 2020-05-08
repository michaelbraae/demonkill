extends KinematicBody2D

var target_direction

var projectile_speed
var projectile_damage

func setTargetDirection(vector2 : Vector2) -> void:
	target_direction = vector2

func setProjectileSpeed(speed = 1):
	projectile_speed = speed

func setProjectileDamage(damage = 1):
	projectile_damage = damage

func collisionEffect():
	pass

func getTargetIdentificationString() -> String:
	return "IS_ENEMY"

func _physics_process(delta : float) -> void:
	if target_direction:
		rotation = target_direction.angle()
		var collision = move_and_collide(
			(target_direction * delta) * projectile_speed
		)
		if collision:
			collisionEffect()
			var collider = collision.get_collider()
			if collider.get(getTargetIdentificationString()):
				#collider is not the node that spawned it
				collider.hit(projectile_damage)
			queue_free()
	else:
		queue_free()
