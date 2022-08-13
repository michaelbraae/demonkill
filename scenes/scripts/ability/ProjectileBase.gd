extends KinematicBody2D

class_name ProjectileBase

onready var sprite = $Sprite

var target_direction

var projectile_speed
var projectile_damage = 1

var target_id

func _ready():
	sprite.hide()
	initialiseConfig()

func initialiseConfig():
	pass

func collisionEffect():
	pass

func _physics_process(_delta : float) -> void:
	var projectile_vector = target_direction
	rotation = projectile_vector.angle()
	sprite.show()
	var collision = move_and_collide(
		projectile_vector.normalized() * projectile_speed
	)
	if collision:
		collisionEffect()
		var collider = collision.get_collider()
		if collider.get(target_id):
			collider.damage(projectile_damage, false)
			collider.knockBack(projectile_vector.angle(), 150, 15)
		queue_free()
