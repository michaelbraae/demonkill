extends Node

class_name Weapon

# warning-ignore-all:return_value_discarded

export var weapon_name: String

export var weapon_description: String

export(int, "EXOTIC", "LEGENDARY", "RARE", "COMMON") var rarity

export(int, "SWORD", "AXES", "SPEAR", "BOW", "PISTOL", "SHOTGUN", "WAND") var archetype

export(int, "STRENGTH", "INTELLIGENCE", "SURVIVAL") var affinity

# the index of the attack sequence which is considered a combo finisher
# ie: the third attack within a combo
export var combo_finish_index: int
# the time between each attack which is still considered part of the combo
export var combo_window_time: float

var current_combo_attack: int = 1
var combo_finish_timer: Timer

# attack speed logic - attacks per second
export var attack_speed: float
var attack_speed_timer: Timer
var attack_available: bool = true

export(Array, PackedScene) var attack_abilities
export(Array, PackedScene) var combo_finisher_abilites

func _ready() -> void:
	combo_finish_timer = Timer.new()
	combo_finish_timer.connect("timeout", self, "combo_finisher_timeout")
	add_child(combo_finish_timer)
	
	attack_speed_timer = Timer.new()
	attack_speed_timer.connect("timeout", self, "attack_speed_timeout")
	add_child(attack_speed_timer)

# the time between each attack in the chain. if the combo continues
func combo_finisher_timeout() -> void:
	combo_finish_timer.stop()
	current_combo_attack = 1

func attack_speed_timeout() -> void:
	attack_speed_timer.stop()
	attack_available = true

# called by the player
# instantiates the attack_effect with the relevant params
func attack(
	target_direction: Vector2,
	source_actor: KinematicBody2D
) -> void:
	attack_available = false
	attack_speed_timer.start(1.0 / attack_speed)
	if current_combo_attack == combo_finish_index:
		# use the combo finisher abilities and reset the combo finish logic
		use_weapon_abilities(target_direction, source_actor, combo_finisher_abilites)
		current_combo_attack = 1
		combo_finish_timer.stop()
	else:
		use_weapon_abilities(target_direction, source_actor, attack_abilities)
	current_combo_attack += 1
	if combo_finish_timer.is_stopped():
		combo_finish_timer.start(1.0 / attack_speed + 0.5)

func use_weapon_abilities(
	target_direction: Vector2,
	_source_actor: KinematicBody2D,
	abilities
) -> void:
	for ability in abilities:
		var ability_instance = ability.instance()
		ability_instance.target_vector = target_direction
		get_parent().add_child(ability_instance)
		ability_instance.doAbility(target_direction, get_parent())
		ability_instance.animatedSprite.play()

# how can this be tied to the player's animation
# USING THE WEAPON TYPE and the players facing direction
# if the weapon is a SWORD, use the sword animation duh
