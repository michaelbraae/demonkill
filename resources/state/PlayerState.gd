extends Node

var current_weapon
var previous_weapon

const max_mana: int = 5
var mana: int = max_mana

var max_health = 200 #15
var health = max_health

var coins = 0

var facing_direction = "up"

var weapon_slot_1: PackedScene
var weapon_slot_2: PackedScene

# how many points has the player put into each of these
var strength_affinity: int = 0
var intelligence_affinity: int = 0
var vitality_affinity: int = 5

func useMana(mana_use: int) -> void:
	if mana - mana_use < 0:
		mana = 0
	else:
		mana -= mana_use

func addMana(mana_add: int) -> void:
	if mana + mana_add > max_mana:
		mana = max_mana
	else:
		mana += mana_add

func addHealth(health_add: int) -> void:
	if health + health_add <= max_health:
		health += health_add
#
#func weapon_slot_1() -> Weapon:
#	return Weapon.instance()
#
#func weapon_slot_2() -> Weapon:
#	return Weapon.instance()

var SPELLS: Dictionary = {
	"0": {},
	"1": {},
	"2": {},
	"3": {},
}
