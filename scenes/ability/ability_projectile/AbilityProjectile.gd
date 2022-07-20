extends Ability

class_name AbilityProjectile

func _physics_process(_delta) -> void:
	if target_vector:
		var collision = move_and_collide(target_vector.normalized() * speed)
		if collision:
			collisionEffect(get_global_position())
			var collider = collision.get_collider()
			if collider.find_node("EffectHandler"):
				for effect in get_node("Effects").get_children():
					damaged_characters.push_front(collider)
					collider.get_node("EffectHandler").applyEffect(effect)
			queue_free()
