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
		collisionEffect(area_parent.get_global_position())
		damaged_characters.push_front(area_parent)
		for effect in get_node("Effects").get_children():
			area_parent.get_node("EffectHandler").applyEffect(effect)

func _physics_process(_delta) -> void:
	if target_vector:
		target_vector = move_and_slide(target_vector.normalized() * speed)
