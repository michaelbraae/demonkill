extends KinematicBody
# Abilities and how they work

# A new class -> Ability
# Should be useable by the player and npcs
# should be self contained
# if AOE, should have a telegraph location and animation
# if hitscan, a straight line telegraph should do fine
# should have an associated animation
# should have associated metrics, damage, range etc
# should be instanced similar to how projectiles work

var ability_name
var has_telegraph

onready var telegraphNode = $TelegraphNode
onready var animatedSprite = $AnimatedSprite

func setAbilityName(name_string : String) -> void:
	ability_name = name_string
