extends Node

class_name Weapon

export(int, "SWORD", "AXES", "SPEAR", "BOW", "PISTOL", "SHOTGUN", "WAND") var archetype

export(int, "STRENGTH", "INTELLIGENCE", "SURVIVAL") var affinity

onready var animatedSprite = $AnimatedSprite

export(Resource) var attack_ability

# called by the player
# instantiates the attack_effect with the relevant params
func attack(
	target_direction: Vector2,
	animation: String,
	source_actor: KinematicBody2D
) -> void:
	attack_ability.instance()
	attack_ability.target_direction = target_direction
	source_actor.get_parent().add_child(attack_ability)
	attack_ability.doEffect()
	animatedSprite.play(animation)

# how can this be tied to the player's animation
# by generalising the player's animation names for the weapons aswell, we can set the same animation
# for both player and weapon, ie: attack_right. exporting only the layers of the weapon we want to use

# we can then quickly produce new weapons by copying the animation frames to a new weapon directory and filling in the frames.
