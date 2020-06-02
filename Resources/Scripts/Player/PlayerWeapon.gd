extends PlayerAnimation

class_name PlayerWeapon

var PUMP_SHOTGUN_SCENE = preload("res://Scenes/Weapons/PumpShotgun/PumpShotgun.tscn")

var available_weapons = {
	"pumpShotgun": {
		"available": true,
	}
}

# should be from PlayerState
var current_weapon

# should be from PlayerState
var weapon_equipped



# should handle the currently equipped weapon

# if it's equipped, it should rotate as usual

# if the player hits melee attack, the gun should be unequipped

# shooting the weapon should equip it.

# this can be empty - nothing equipped

# if unequipped, the weapon should rest on the players back
