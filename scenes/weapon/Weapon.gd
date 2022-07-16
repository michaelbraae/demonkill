extends Node

class_name Weapon

export var weapon_name: String

export var weapon_description: String

export(int, "EXOTIC", "LEGENDARY", "RARE", "COMMON") var rarity

export(int, "SWORD", "AXES", "SPEAR", "BOW", "PISTOL", "SHOTGUN", "WAND") var archetype

export(int, "STRENGTH", "INTELLIGENCE", "SURVIVAL") var affinity

# how many attacks per second can the player perform with this weapon
export var attack_speed: float

# the index of the attack sequence which is considered a combo finisher
# ie: the third attack within a combo
export var combo_finish_index: int
# the time between each attack which is still considered part of the combo
export var combo_window_time: float

var current_combo_attack: int = 1
var combo_finish_timer: Timer

#export var attack_1: PackedScene

export(Array, PackedScene) var attack_abilities
#export(Array, Resource) var combo_finisher_abilites

# warning-ignore-all:return_value_discarded

func _ready() -> void:
	combo_finish_timer = Timer.new()
	combo_finish_timer.connect("timeout", self, "combo_finisher_timeout")
	add_child(combo_finish_timer)


# the time between each attack in the chain. if the combo continues
func combo_finisher_timeout() -> void:
	current_combo_attack = 1
	combo_finish_timer.stop()

func can_attack() -> bool:
	# use the attack_speed variable to determine if the player is able to attack
	return true

# called by the player
# instantiates the attack_effect with the relevant params
func attack(
	target_direction: Vector2,
	source_actor: KinematicBody2D
) -> void:
	use_weapon_abilities(target_direction, get_parent(), attack_abilities)
#	if current_combo_attack == combo_finish_index:
		# use the combo finisher abilities and reset the combo finish logic
#		use_weapon_abilities(target_direction, source_actor, combo_finisher_abilites)
#		current_combo_attack = 1
#		combo_finish_timer.stop()
#	else:
#		use_weapon_abilities(target_direction, source_actor, attack_abilities)
	current_combo_attack += 1
	if combo_finish_timer.is_stopped():
		combo_finish_timer.start(combo_window_time)

func use_weapon_abilities(
	target_direction: Vector2,
	_source_actor: KinematicBody2D,
	abilities
) -> void:
#	var attack_instance = attack_1.instance()
#	attack_instance.target_vector = target_direction
#	get_parent().add_child(attack_instance)
##	attack_instance.doEffect()
#	attack_instance.animatedSprite.play()
	for ability in abilities:
		var attack_instance = ability.instance()
		attack_instance.target_vector = target_direction
		get_parent().add_child(attack_instance)
		attack_instance.doAbility(target_direction, get_parent())
		attack_instance.animatedSprite.play()

# how can this be tied to the player's animation
# by generalising the player's animation names for the weapons aswell, we can set the same animation
# for both player and weapon, ie: attack_right. exporting only the layers of the weapon we want to use

# we can then quickly produce new weapons by copying the animation frames to a new weapon directory and filling in the frames.
