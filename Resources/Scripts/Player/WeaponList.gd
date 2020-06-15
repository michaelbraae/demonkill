extends Node

const Weapons = {
	"PumpShotgun": {
		"name": "PumpShotgun",
		"path": "res://Resources/Weapons/PumpShotgun/PumpShotgun.tscn",
		"iconPath" : "",
	},
}

func getPumpShotgun() -> Dictionary:
	return Weapons['PumpShotgun']

#func getWeaponFromList() -> Dictionary:
