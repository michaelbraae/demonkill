extends Ability

class_name AbilityMelee

# warning-ignore-all:return_value_discarded

func _ready() -> void:
	area2D.connect("area_entered", self, "area_entered")

func area_entered(area) -> void:
	var area_parent = area.get_parent()
	if (
		area_parent != source_actor
		and area.get_name() == 'HitBox'
		and damage_frames.has(animatedSprite.get_frame())
		and not damaged_characters.has(area_parent)
	):
		damaged_characters.push_front(area_parent)
		area_parent.knockBack(
			source_actor.get_angle_to(area_parent.get_global_position()),
			200,
			20
		)
		collisionEffect(area_parent.get_global_position())
		# apply effects
		for effect in get_node("Effects").get_children():
			area_parent.get_node("EffectHandler").applyEffect(effect)

func _physics_process(_delta) -> void:
	if target_vector:
		target_vector = move_and_slide(target_vector.normalized() * speed)

# on create effect, so that we can make a small animation occur when the effect is first initialised ie: Muzzle flash

# the effect itelf, the swipe, the fireball etc.

# the onhit effect, which effect is created when the fireball or swipe hits a target or collides with something.
