extends KinematicBody2D

onready var sprite = $Sprite

var target_direction

var projectile_speed
var projectile_damage

var target_id

func _ready():
	sprite.hide()
	initialiseConfig()

func initialiseConfig():
	pass

func setTargetDirection(target_direction_vector : Vector2) -> void:
	target_direction = target_direction_vector

func getTargetDirection() -> Vector2:
	return target_direction

func setProjectileSpeed(speed = 1):
	projectile_speed = speed

func setProjectileDamage(damage = 1):
	projectile_damage = damage

func collisionEffect():
	pass

func getTargetId() -> String:
	return target_id

func setTargetId(id_var) -> void:
	target_id = id_var

func _physics_process(delta : float) -> void:
	var projectile_vector = getTargetDirection()
	if projectile_vector:
		rotation = projectile_vector.angle()
		# hide the sprite until after it's rotated
		sprite.show()
		var collision = move_and_collide(
			projectile_vector.normalized() * projectile_speed
		)
		if collision:
			collisionEffect()
			var collider = collision.get_collider()
			if collider.get(getTargetId()):
				collider.hit(projectile_damage)
			queue_free()
	else:
		queue_free()
