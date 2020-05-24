extends KinematicBody2D
# Abilities and how they work

class_name TelegraphedAOEAbility

# A new class -> Ability
# Should be useable by the player and npcs
# should be self contained
# if AOE, should have a telegraph location and animation
# if hitscan, a straight line telegraph should do fine
# should have an associated animation
# should have associated metrics, damage, range etc
# should be instanced similar to how projectiles work

#enum {
#	TELEGRAPHING, # The warm up stage of a telegraph ability
#	IN_FLIGHT, # While the ability is travelling through the air
#	HIT, # Once the animation is doing damage in an area on hit
#	AOE_EFFECT, # after the ability has landed, the AOE effect: burning, poison etc
#}

# The relative position where the ability will land
var target_vector

func setTargetVector(tele_vector_arg : Vector2) -> void:
	target_vector = tele_vector_arg

func getTargetVector() -> Vector2:
	return target_vector

func _on_TelegraphSprite_animation_finished() -> void:
	pass







