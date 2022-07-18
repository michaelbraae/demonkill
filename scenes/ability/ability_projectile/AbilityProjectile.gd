extends Ability

class_name AbilityProjectile

func _physics_process(_delta) -> void:
	if target_vector:
		var collision = move_and_collide(target_vector.normalized() * speed)
		if collision:
			collisionEffect(get_global_position())
			var collider = collision.get_collider()
			for effect in get_node("Effects").get_children():
				collider.get_node("EffectHandler").applyEffect(effect)
			if collider.has_method("knockBack"):
				collider.knockBack(target_vector.angle(), 150, 15)
			queue_free()
