extends Node

const Weapons = {
	'pump_shotgun': {
		'name': 'pump_shotgun',
		'path': 'res://resources/weapons/PumpShotgun/PumpShotgun.tscn',
		'iconPath' : '',
	},
}

func getPumpShotgun() -> Dictionary:
	return Weapons['pump_shotgun']
