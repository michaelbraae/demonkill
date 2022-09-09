extends Ability

class_name AbilityProjectile

func _physics_process(_delta) -> void:
	if target_vector:
		var collision = move_and_collide(target_vector.normalized() * speed)
		if collision:
			collisionEffect(get_global_position())
			var collider = collision.get_collider()
			if collider.find_node("EffectHandler"):
				if collider is CharacterBase and on_hit_prevent_continue(collider):
					return
				for effect in get_node("Effects").get_children():
					damaged_characters.push_front(collider)
					collider.get_node("EffectHandler").apply_effect(effect)
			if !has_landed:
				has_landed = true
				emit_signal("ability_landed", ABILITY_TYPE.PROJECTILE)
			queue_free()
