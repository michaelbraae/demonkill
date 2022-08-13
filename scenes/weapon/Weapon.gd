extends Node

class_name Weapon

# warning-ignore-all:return_value_discarded

export var weapon_name: String

export var weapon_description: String

export(String, "EXOTIC", "LEGENDARY", "RARE", "COMMON") var rarity

export(String, "SWORD", "AXES", "SPEAR", "BOW", "PISTOL", "SHOTGUN", "WAND") var archetype

export(String, "STRENGTH", "INTELLIGENCE", "VITALITY") var affinity

# the index of the attack sequence which is considered a combo finisher
# ie: the third attack within a combo
export var combo_finish_index: int

var current_combo_attack: int = 1
var combo_finish_timer: Timer

# attack speed logic - attacks per second
export var attack_speed: float = 0.5
var attack_speed_timer: Timer
var attack_available: bool = true

#export(PackedScene) var weapon_pickup

export(String, FILE) var weapon_pickup

export(Array, PackedScene) var attack_abilities
export(Array, PackedScene) var combo_finisher_abilites

export var weapon_icon: Texture

func _ready() -> void:
	combo_finish_timer = Timer.new()
	combo_finish_timer.one_shot = true
	combo_finish_timer.connect("timeout", self, "combo_finisher_timeout")
	add_child(combo_finish_timer)
	
	attack_speed_timer = Timer.new()
	attack_speed_timer.one_shot = true
	attack_speed_timer.connect("timeout", self, "attack_speed_timeout")
	add_child(attack_speed_timer)

# the time between each attack in the chain. if the combo continues
func combo_finisher_timeout() -> void:
	current_combo_attack = 1

func attack_speed_timeout() -> void:
	attack_available = true

# called by the player
# instantiates the attack_effect with the relevant params
func attack(
	target_direction: Vector2,
	source_actor: KinematicBody2D
) -> void:
	attack_available = false
	
	# attacks per second, so divide 1.0 by attack_speed
	attack_speed_timer.start(1.0 / attack_speed)
	# only use the combo finisher logic if the index is greater than 0
	if !combo_finish_index or !combo_finisher_abilites.size():
		use_weapon_abilities(target_direction, source_actor, attack_abilities)
	else:
		if current_combo_attack == combo_finish_index:
			# use the combo finisher abilities and reset the combo finish logic
			use_weapon_abilities(target_direction, source_actor, combo_finisher_abilites)
			current_combo_attack = 1
			combo_finish_timer.stop()
		else:
			use_weapon_abilities(target_direction, source_actor, attack_abilities)
			current_combo_attack += 1
			if combo_finish_timer.is_stopped():
				# start the combo finish timer
				# same length as window between attacks + extra to capture combo
				combo_finish_timer.start(1.0 / attack_speed + 0.5)

func use_weapon_abilities(
	target_direction: Vector2,
	_source_actor: KinematicBody2D,
	abilities
) -> void:		
	for ability in abilities:
		if ability:
			var ability_instance = ability.instance()
			ability_instance.target_vector = target_direction
			get_tree().get_root().add_child(ability_instance)
			ability_instance.do_ability(target_direction, get_parent())
			ability_instance.animatedSprite.play()

func drop_weapon() -> void:
	if weapon_pickup:
		var weapon_pickup_instance = load(weapon_pickup).instance()
		get_tree().get_current_scene().get_node("YSort").add_child(weapon_pickup_instance)

# how can this be tied to the player's animation
# USING THE WEAPON TYPE and the players facing direction
# if the weapon is a SWORD, use the sword animation duh
