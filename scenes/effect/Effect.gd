extends KinematicBody2D

class_name Effect

var source_actor

var target_vector: Vector2

const damage_frames = []

export var speed: int

func doEffect() -> void:
	pass

func setCollideWithEnemies() -> void:
	$Area2D.set_collision_mask_bit(2, true)

func setCollideWithPlayer() -> void:
	$Area2D.set_collision_mask_bit(1, true)

func damageOverlappingAreas() -> void:
	pass

# on create effect, so that we can make a small animation occur when the effect is first initialised ie: Muzzle flash

# the effect itelf, the swipe, the fireball etc.

# the onhit effect, which effect is created when the fireball or swipe hits a target or collides with something.
