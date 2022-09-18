extends Ability

class_name AbilityProjectile

func _ready() -> void:
	$Area2D.connect("area_entered", self, "projectile_area_entered")

func _physics_process(_delta) -> void:
	if target_vector:
		var collision = move_and_collide(target_vector.normalized() * speed)
		if collision:
			collisionEffect(get_global_position())
			queue_free()

func projectile_area_entered(area) -> void:
	if area.get_name() == "HitBox" and source_actor != area.get_parent():
		set_physics_process(false)
		if area.get_parent().find_node("EffectHandler"):
			if area.get_parent() is CharacterBase and on_hit_prevent_continue(area.get_parent()):
				return
			for effect in get_node("Effects").get_children():
				damaged_characters.push_front(area.get_parent())
				area.get_parent().get_node("EffectHandler").apply_effect(effect)
		if !has_landed:
			has_landed = true
			emit_signal("ability_landed", ABILITY_TYPE.PROJECTILE)
		collisionEffect(get_global_position())
		queue_free()
