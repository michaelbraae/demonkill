extends KinematicBody2D
# Abilities and how they work

# A new class -> Ability
# Should be useable by the player and npcs
# should be self contained
# if AOE, should have a telegraph location and animation
# if hitscan, a straight line telegraph should do fine
# should have an associated animation
# should have associated metrics, damage, range etc
# should be instanced similar to how projectiles work

onready var telegraphNode = $TelegraphNode
onready var animatedSprite = $AnimatedSprite


var ability_name
var has_telegraph
var target_vector

func getTelegraphNode() -> Node2D:
	return telegraphNode

func getAnimatedSprite() -> AnimatedSprite:
	return animatedSprite

func setAbilityName(name_string : String) -> void:
	ability_name = name_string

func getAbilityName() -> String:
	return ability_name

func setTargetVector(target_vector_arg : Vector2) -> void:
	target_vector = target_vector_arg

func getTargetVector() -> Vector2:
	return target_vector
