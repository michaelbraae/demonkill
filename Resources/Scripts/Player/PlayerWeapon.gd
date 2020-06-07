extends PlayerNavigation

class_name PlayerWeapon

# = preload("res://Resources/Weapons/PumpShotgun/PumpShotgun.tscn")

# should be from PlayerState
var current_weapon
var weapon_equipped
func _ready():
	var current_weapon_config = PlayerState.getCurrentWeaponConfig()
	var weapon_scene = load(current_weapon_config["path"])
# should be from PlayerState


# should handle the currently equipped weapon

# if it's equipped, it should rotate as usual

# if the player hits melee attack, the gun should be unequipped

# shooting the weapon should equip it.

# this can be empty - nothing equipped?
# maybe two hands? floating

# if unequipped, the weapon should rest on the players back
