extends Node

var current_weapon
var previous_weapon

const max_mana: int = 5
var mana: int = max_mana

var max_health = 15
var health = max_health

var coins = 0

func useMana(mana_use: int) -> void:
	if mana - mana_use < 0:
		mana = 0
	else:
		mana -= mana_use

func addHealth(health_add: int) -> void:
	if health + health_add <= max_health:
		health += health_add

var SPELLS: Dictionary = {
	"0": {},
	"1": {},
	"2": {},
	"3": {},
}
