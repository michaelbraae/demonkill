extends Node

class_name Weapon

export(int, "SWORD", "AXES", "SPEAR", "BOW", "PISTOL", "SHOTGUN", "WAND") var archetype

export(int, "STRENGTH", "INTELLIGENCE", "SURVIVAL") var affinity

onready var animatedSprite = $AnimatedSprite

# the index of the attack sequence which is considered a combo finisher
# ie: the third attack within a combo
export var combo_finish_index: int
export var combo_window_time: float

var current_combo_attack: int = 1
var combo_finish_timer: Timer

export(Array, Resource) var attack_abilities
export(Array, Resource) var combo_finisher_abilites

func _ready() -> void:
	combo_finish_timer = Timer.new()
	combo_finish_timer.connect("timeout", self, "combo_finisher_timeout")
	add_child(combo_finish_timer)

func combo_finisher_timeout() -> void:
	current_combo_attack = 1
	combo_finish_timer.stop()

# called by the player
# instantiates the attack_effect with the relevant params
func attack(
	target_direction: Vector2,
	animation: String,
	source_actor: KinematicBody2D
) -> void:
	if current_combo_attack == combo_finish_index:
		weapon_ability(target_direction, animation, source_actor)
	else:
		combo_finisher(target_direction, animation, source_actor)
	current_combo_attack += 1
	if combo_finish_timer.is_stopped():
		combo_finish_timer.start(combo_window_time)

func weapon_ability(
	target_direction: Vector2,
	animation: String,
	source_actor: KinematicBody2D
) -> void:
	for ability in attack_abilities:
		ability.instance()
		ability.target_direction = target_direction
		source_actor.get_parent().add_child(ability)
		ability.doEffect()
		ability.animatedSprite.play(animation)

func combo_finisher(
	target_direction: Vector2,
	animation: String,
	source_actor: KinematicBody2D
) -> void:
	for ability in combo_finisher_abilites:
		ability.instance()
		ability.target_direction = target_direction
		source_actor.get_parent().add_child(ability)
		ability.doEffect()
		ability.animatedSprite.play(animation)

# how can this be tied to the player's animation
# by generalising the player's animation names for the weapons aswell, we can set the same animation
# for both player and weapon, ie: attack_right. exporting only the layers of the weapon we want to use

# we can then quickly produce new weapons by copying the animation frames to a new weapon directory and filling in the frames.
