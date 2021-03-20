extends Node

var current_weapon
var previous_weapon

var max_health = 10
var health = max_health

const PumpShotgun = {
	"name": "PumpShotgun",
	"path": "res://Resources/Weapons/PumpShotgun/PumpShotgun.tscn",
	"iconPath" : "",
}

func _ready():
	current_weapon = PumpShotgun

func setCurrentWeapon(NewWeapon : Dictionary):
	current_weapon = NewWeapon

func getCurrentWeapon() -> Dictionary:
	return current_weapon

func setPreviousWeapon(PreviousWeapon : Dictionary):
	previous_weapon = PreviousWeapon

func getPreviousWeapon() -> Dictionary:
	return previous_weapon

# to alternate, changeWeapon(getPreviousWeapon())
func changeWeapon(NewWeapon : Dictionary) -> void:
	setPreviousWeapon(getCurrentWeapon())
	setCurrentWeapon(NewWeapon)
