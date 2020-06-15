extends Node

var weapon_list_script = load("res://Resources/State/WeaponSlots.gd")
var WeaponList

var weapon_at_slot = {
	1: WeaponList.getPumpShotgun(),
	2: WeaponList.getPumpShotgun(),
	3: WeaponList.getPumpShotgun(),
	4: WeaponList.getPumpShotgun(),
	5: WeaponList.getPumpShotgun(),
	6: WeaponList.getPumpShotgun(),
	7: WeaponList.getPumpShotgun(),
	8: WeaponList.getPumpShotgun(),
}

func getWeaponAtSlot(slot_number) -> Dictionary:
	return weapon_at_slot[slot_number]

func _ready():
	WeaponList = weapon_list_script.instance()

