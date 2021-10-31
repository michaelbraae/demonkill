extends Node

var current_weapon
var previous_weapon

var max_health = 7
var health = max_health

var coins = 0

var SPELLS: Dictionary = {
	"0": {},
	"1": {},
	"2": {},
	"3": {},
}

const PumpShotgun = {
	'name': 'PumpShotgun',
	'path': 'res://Resources/Weapons/PumpShotgun/PumpShotgun.tscn',
	'iconPath' : '',
}

func _ready():
	current_weapon = PumpShotgun

func changeWeapon(new_weapon : Dictionary) -> void:
	previous_weapon = current_weapon
	current_weapon = new_weapon

